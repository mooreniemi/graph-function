# Graph::Function

When I work on katas and exercises I found I often wanted to compare my implementations. After doing so a half dozen times I noticed some patterns, and figured it'd be valuable to capture those into an easier API to work with.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graph-function'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graph-function

## Usage

The simplest usage--suitable for a large class of exercises--is if you're comparing two functions that take a single argument of `Array[Int]` type:

```ruby
c = YourClass.new # this class has #function_name_one & #function_name_two
comparison = Graph::Function::Comparison.new
comparison.of(c.method(:function_name_one), c.method(:function_name_two))
# => will output an xquartz graph
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mooreniemi/graph-function. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

