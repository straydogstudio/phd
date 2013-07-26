require 'sqlite3'
module Phd
  module DB
    class SQlite3
      def initialize(path)
        @path = path
        @db = SQLite3::Database.new path
        initialize_database
        initialize_statements
      end

      def begin_transaction
        @db.execute("BEGIN TRANSACTION")
      end

      def clear_date(date)
        @db.execute "DELETE FROM stats WHERE date = ?", date
      end

      def clear_date_time(date, time)
        @db.execute "DELETE FROM stats WHERE date = ? AND time = ?", date, time
      end

      def end_transaction
        @db.execute("END TRANSACTION")
      end

      def file_ids_by_path
        Hash[ @db.execute("SELECT path, id FROM files") ]
      end

      def initialize_database
        unless @db.get_first_value("SELECT name FROM sqlite_master WHERE type='table' AND name='files';")
          sql = <<SQL
            create table files (
              id integer primary key,
              path text
            );
            create index path_index on files (path);
SQL
           @db.execute(sql)
        end
        unless @db.get_first_value("SELECT name FROM sqlite_master WHERE type='table' AND name='stats';")
          sql = <<SQL
            create table stats (
              id integer primary key,
              file_id integer,
              date text,
              time text,
              inode integer,
              size integer,
              mtime integer,
              is_dir integer,
              depth integer,
              node_left integer,
              node_right integer
            );
            create index file_id_index on stats (file_id);
            create index date_index on stats (date);
            create index inode_index on stats (inode);
            create index depth_index on stats (depth);
            create index node_left_index on stats (node_left);
            create index node_right_index on stats (node_right);
SQL
          @db.execute(sql)
        end
      end

      def initialize_statements
        @stmt_file_insert  = @db.prepare("INSERT INTO files VALUES (NULL, ?)")
        @stmt_last_file_id = @db.prepare("SELECT last_insert_rowid();")
        @stmt_stat_insert  = @db.prepare("INSERT INTO stats VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
      end

      def insert_file(file)
        @stmt_file_insert.execute(file)
      end

      def insert_stat(file_id, date, time, ino, size, mtime, is_directory, depth, node_left, node_right)
        @stmt_stat_insert.execute(file_id, date, time, ino, size, mtime, is_directory, depth, node_left, node_right)
      end

      def last_inserted_file_id
        @stmt_last_file_id.execute.first.to_a.first
      end
    end
  end
end
