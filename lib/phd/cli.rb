module Phd
  class CLI
    def initialize
      @opts = Trollop::options do
        banner "Usage: phd <options> directory"
        opt :database, "File database", :short => 'd', :type => String
        opt :port, "HTTP port", :short => 'p', :default => 8888
        opt :verbose, "Verbose output", :short => 'v', :default => false
        opt :reread_file, "Reread files", :short => 'r', :default => false
      end

      @opts[:directory] = ARGV.shift
      @opts[:database] ||= "/tmp/phd_#{Time.now.strftime("%Y%m%d%H%M%S")}.db"

      Trollop::die "Directory or database must be specified" if @opts[:directory].nil? && @opts[:database].nil?
      Trollop::die :directory, "must exist" unless @opts[:directory].nil? || File.exist?(@opts[:directory])

      puts "phd: Indexing #{@opts[:directory]} using database: #{@opts[:database]}"
    end

    def opts
      @opts
    end

    def execute
      @db = Phd::DB::SQlite3.new(@opts[:database])
      if @opts[:database]
        @indexer = Phd::Indexer.new(@db, @opts[:directory]).index(@opts)
      end
    end
  end
end