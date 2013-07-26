module Phd
  class Server
    def initialize(db, root_path)
      @db   = db
      @root = root_path
    end

    def run(opts = {})
      require 'sinatra'
      set :run, true
      get '/' do
        return "hello: #{rand}"
      end
    end
  end
end
