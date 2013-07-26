require 'spec_helper'
require 'phd'
require 'sqlite3'
describe 'Phd' do
  before :all do
    @date, @time = Time.now.strftime("%Y%m%d_%H%M%S").split(/_/)
    @opts = {
      directory: "spec/dummy",
      database: "tmp/phd_#{@date}_#{@time}.db"
    }
    @db = Phd::DB::SQlite3.new @opts[:database]
    @direct_db = SQLite3::Database.new @opts[:database]
  end

  after :all do
    File.unlink(@opts[:database]) if File.exists?(@opts[:database])
  end

  it "initializes the database" do
    #should have tables
    %w{files stats}.each do |name|
      @direct_db.get_first_value("SELECT name FROM sqlite_master WHERE type='table' AND name='#{name}';")
    end
    #table columns
    files_columns = [[0, "id", "integer", 0, nil, 1], [1, "path", "text", 0, nil, 0]]
    @direct_db.execute("pragma table_info(files)").should match_array(files_columns)
    stats_columns = [[0, "id", "integer", 0, nil, 1], [1, "file_id", "integer", 0, nil, 0], [2, "date", "text", 0, nil, 0], [3, "time", "text", 0, nil, 0], [4, "inode", "integer", 0, nil, 0], [5, "size", "integer", 0, nil, 0], [6, "mtime", "integer", 0, nil, 0], [7, "is_dir", "integer", 0, nil, 0], [8, "depth", "integer", 0, nil, 0], [9, "node_left", "integer", 0, nil, 0], [10, "node_right", "integer", 0, nil, 0]]
    @direct_db.execute("pragma table_info(stats)").should match_array(stats_columns)
  end

  it "indexes the directory" do
    @indexer = Phd::Indexer.new(@db, @opts[:directory]).index(@opts)
    #should have files
    files_data = [[1, "spec/dummy/one.txt"], [2, "spec/dummy/three"], [3, "spec/dummy/three/five.txt"], [4, "spec/dummy/three/four.txt"], [5, "spec/dummy/three/six"], [6, "spec/dummy/three/six/seven.txt"], [7, "spec/dummy/two.txt"]]
    @direct_db.execute("SELECT * FROM files").should match_array(files_data)
    #should have specs
    stats_data = [[1, 1, @date, @time, 33957578, 57, 1368225981, 0, 3, 2, 2], [2, 2, @date, @time, 33957582, 170, 1368225928, 1, 3, 3, 12], [3, 3, @date, @time, 33957587, 289, 1368226004, 0, 4, 5, 5], [4, 4, @date, @time, 33957584, 231, 1368225999, 0, 4, 7, 7], [5, 5, @date, @time, 33957588, 102, 1368225937, 1, 4, 8, 11], [6, 6, @date, @time, 33957589, 0, 1368225879, 0, 5, 10, 10], [7, 7, @date, @time, 33957579, 115, 1368225989, 0, 3, 14, 14]]
    @direct_db.execute("SELECT * FROM stats").should match_array(stats_data)
  end

  pending "removes a date and time from the db" do
  end
end
