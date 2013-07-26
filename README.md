# Phd

Phd is a tool to browse changes in disk space usage. It creates a database and creates SVG images of the usage. The svg uses area and color to display both file size and size change relative to the compared date. A cgi wrapper is also available for browsing usage. Phd is a near complete rewrite of philesight (http://zevv.nl/play/code/philesight/) with many changes.

## Installation

    $ gem install phd

## Usage

    $ phd <directory>

or to reuse a database:

    $ phd <directory> -d <database>

##Plans

* Sinatra web interface, displaying files by directory, with an svg display of file use/changes.
* MySQL support
* Remote shell support
* Windows support
* Automatic start with inetd/xinetd

##Dependencies

- [Sinatra](https://github.com/sinatra/sinatra)
- [SQLite3](https://github.com/luislavena/sqlite3-ruby)
- [SQLite](http://www.sqlite.org)
- [progress_bar](https://github.com/paul/progress_bar)

##Authors

* [Noel Peden](https://github.com/straydogstudio)

## Contributing

The usual fork, change, test, pull request.

## Change log

**July 26, 2013**: 0.1.2 release

- Rename gem to phd

**May 17, 2013**: 0.1.1 release

- Basic command line usage. Files searched and database filled with stats.

**June 14, 2012**: 0.1.0 release

- Initial posting.
