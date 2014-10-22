# Ruby Object Mapper

ROM is an experimental ruby ORM.

## Status

[![Gem Version](https://badge.fury.io/rb/rom.svg)][gem]
[![Build Status](https://travis-ci.org/rom-rb/rom.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/rom-rb/rom.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/rom-rb/rom/badges/gpa.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/rom-rb/rom/badges/coverage.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/rom-rb/rom.svg?branch=master)][inchpages]

[gem]: https://rubygems.org/gems/rom
[travis]: https://travis-ci.org/rom-rb/rom
[gemnasium]: https://gemnasium.com/rom-rb/rom
[codeclimate]: https://codeclimate.com/github/rom-rb/rom
[coveralls]: https://coveralls.io/r/rom-rb/rom
[inchpages]: http://inch-ci.org/github/rom-rb/rom/

Project is being rebuilt from scratch. Watch this space.

## Synopsis

``` ruby
rom = ROM.setup(sqlite: "sqlite::memory")

rom.sqlite.connection.run(
  <<-SQL
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name STRING,
    age INTEGER
  )
  SQL
)

rom.schema do
  base_relation(:users) do
    repository :sqlite

    attribute :id, Integer
    attribute :name, String
    attribute :age, Integer
  end
end

# mapping to PORO
class User
  attr_reader :id, :name, :age

  def initialize(attributes)
    @id, @name, @age = attributes.values_at(:id, :name, :age)
  end
end

rom.mappers do
  relation(:users) do
    model User
    map :id, :name, :age
  end
end

rom.relations do
  users do
    def by_name(name)
      where(name: name)
    end

    def adults
      where { age >= 18 }
    end
  end
end

rom.schema[:users].insert(name: "Joe", age: 17)
rom.schema[:users].insert(name: "Jane", age: 18)

puts rom.relations.users.by_name("Jane").adults.to_a.inspect
# => [{:id=>2, :name=>"Jane", :age=>18}]

puts rom.relations.users(mapper: true).by_name("Jane").adults.to_a.inspect
# => [#<User:0x007fdba161cc48 @id=2, @name="Jane", @age=18>]
```

## ROADMAP

The interface will be very similar to previous versions. The biggest
change is using Sequel for RDBMS and adding a new RA in-memory layer for
combining data in-memory.

Here's a top-level TODO:

* Add adapter interface
* Add sequel adapter
* Add redis adapter (just to prove that stuff works with different adapters)
* Add a couple of RA operations
* Rebuild relation and mapper definition DSL
* Release 0.3.0 \o/

## Community

* [![Gitter chat](https://badges.gitter.im/rom-rb/chat.png)](https://gitter.im/rom-rb/chat)
* [Ruby Object Mapper](https://groups.google.com/forum/#!forum/rom-rb) mailing list

## License

See `LICENSE` file.
