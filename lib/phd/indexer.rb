module Phd
  class Indexer
    def initialize(db, path)
      @db   = db
      @path = path
    end

    def index(opts = {})
      verbose = opts[:verbose].nil? ? true : opts[:verbose]
      @files = nil if opts[:reread_files]
      today, now = Time.now.strftime("%Y%m%d %H%M%S").split
      @db.clear_date(today)
      #retrieve files
      if verbose
        $stdout.sync = true
        print "Reading directory ... "
      end
      @files ||= Dir.glob("#{@path}/**/*").reject{|f| f =~ /\/\.\.?$/}
      puts @files.length if verbose
      #construct depth hash
      children = Hash.new(0)
      depths = {}
      if verbose
        puts "Generating file depth:"
        bar = ProgressBar.new(@files.length, :bar, :percentage)
      end
      @files.each do |file|
         bar.increment! if verbose
         depth  = 1
         i_last = 0
         i = file.index('/', i_last)
         while i
            depth += 1
            children[file[0,i]] += 1
            i_last = i+1
            i = file.index('/', i_last)
         end
         depths[file] = depth
      end
      #place file stats in db
      node_left = 0
      dir_node_rights = [0]
      if verbose
        puts "\nSaving stats:"
        bar = ProgressBar.new(@files.length, :bar, :percentage)
      end
      file_ids_by_path = @db.file_ids_by_path
      @db.begin_transaction
      @files.each do |file|
         bar.increment! if verbose
         stat = File.lstat(file)
         node_left += 1
         while node_left == dir_node_rights.last
            node_left += 1
            dir_node_rights.pop
         end
         if stat.directory?
            dir_node_rights << node_left + children[file] * 2 + 1
            node_right = dir_node_rights.last
         else
            node_right = node_left += 1
         end
         file_id = file_ids_by_path[file]
         unless file_id
            @db.insert_file(file)
            file_id = @db.last_inserted_file_id
         end
         @db.insert_stat(file_id, today, now, stat.ino, stat.size, stat.mtime.to_i, stat.directory? ? 1 : 0, depths[file], node_left, node_right)
      end
      @db.end_transaction
      self
    end
  end
end