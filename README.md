```
                        .-.      / \        _
            ^^         /   \    /^./\__   _/ \
          _        .--'\/\_ \__/.      \ /    \  ^^  ___
         / \_    _/ ^      \/  __  :'   /\/\  /\  __/   \
        /    \  /    .'   _/  /  \   ^ /    \/  \/ .`'\_/\
       /\/\  /\/ :' __  ^/  ^/    `--./.'  ^  `-.\ _    _:\ _
      /    \/  \  _/  \-' __/.' ^ _   \_   .'\   _/ \ .  __/ \
    /\  .-   `. \/     \ / -.   _/ \ -. `_/   \ /    `._/  ^  \
   /  `-.__ ^   / .-'.--'    . /    `--./ .-'  `-.  `-. `.  -  `.
 @/        `.  / /      `-.   /  .-'   / .   .'   \    \  \  .-  \%
 @(88%@)@%% @)&@&(88&@.-_=_-=_-=_-=_-=_.8@% &@&&8(8%@%8)(8@%8 8%@)%
 @88:::&(&8&&8::JGS:&`.~-_~~-~~_~-~_~-~~=.'@(&%::::%@8&8)::&#@8::::
 `::::::8%@@%:::::@%&8:`.=~~-.~~-.~~=..~'8::::::::&@8:::::&8::::::'
  `::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'

```

# Graph::Function

This gem's goal is to make it easy to compare the [asymptotic performance](https://en.wikipedia.org/wiki/Asymptotic_analysis) of two or more functions via graphing.

When I work on katas and exercises I found I often wanted to compare my implementations. After doing so a half dozen times I noticed some patterns, and figured it'd be valuable to capture those into an easier API to work with. While working on a kata I like the immediacy of replotting back on x11, but because of gnuplot's structure it is just as easy to get images or html canvas graphs.

## Installation

Because this gem depends on `gnuplot` and `xquartz`, we need to follow their [prereq steps](https://github.com/rdp/ruby_gnuplot#pre-requisites-and-installation):

```
# these will vary by your system, mine is mac
brew install Caskroom/cask/xquartz
brew install gnuplot --with-x11
# verify you have x11
xpdyinfo | grep version
```

Now we're set. Add this line to your application's Gemfile:

```ruby
gem 'graph-function'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graph-function

## Usage

### TL;DR

From the [comparing ints example](examples/comparing_ints.rb):

```ruby
require 'graph/function'
Graph::Function.as_gif
Graph::Function::IntsComparison.of(method(:sort), method(:bubble_sort))
```

Produces:

![comparing ints](examples/comparing_ints.gif)

### Setup

To set up, you only need the following:

```ruby
require 'graph/function'
Graph::Function.as_x11
```

If you don't want to output to [x11](https://www.xquartz.org/), just set `config.terminal` to a different option. Two convenience methods exist for `gif` and `canvas`:

```ruby
# by default file will be set to name of the executing file and dumped in its dir
# or you can set file yourself like so:
Graph::Function.as_gif(File.expand_path('../comparing_ints.gif', __FILE__))
Graph::Function.as_canvas(File.expand_path('../comparing_ints.html', __FILE__))
```

You can use anything else gnuplot [respects as a terminal](http://mibai.tec.u-ryukyu.ac.jp/~oshiro/Doc/gnuplot_primer/gptermcmp.html), even outputting to just `txt`!

```ruby
Graph::Function.configure do |config|
  config.terminal = 'dumb'
  config.output = File.expand_path('../your_graph_name.txt', __FILE__)
  config.step = (0..10_000).step(1000).to_a # default value
  config.trials = 1
end
```

In configuration, you can control the "step" size of `x` in the plot. Its default value is `(0..10_000).step(1000).to_a` (`[0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]`) but you can make it as fine or rough grained as you need up to any size.

You can also set a number of trials over which to average execution times.

### Graphing

The simplest usage (suitable for a large class of exercises, in my experience) is if you're comparing two functions that take a single argument of `Array[Int]` type:

```ruby
c = YourClass.new # this class has #function_name_one & #function_name_two
Graph::Function::IntsComparison.of(c.method(:function_name_one), c.method(:function_name_two))
# => will output an xquartz graph
```

![comparison](spec/graph/two_func.gif)

For more complex use cases, you'll be creating a `Graph::Function::Comparison` with some generator of data, and executing `#of` with `Method` objects or `Proc`s that operate on the same parameter types<sup id="a1">[1](#f1)</sup>. (Note because `IntsComparison` *does not need a generator*, `.of` is a class method instead.)

### Generators

To generate values of the type needed by your function, you can write
a generator in Ruby or use the provided dependency
[Rantly](https://github.com/hayeah/rantly).

Here's an example of a simple Ruby generator, it's just a `Proc` parameterized on `size`:

```ruby
tiny_int_generator = proc {|size| Array.new(size) { rand(-9...9) } }
comparison = Graph::Function::Comparison.new(tiny_int_generator)
```

For Rantly usage, there's great documentation on generating many different kinds of data in
their documentation, but here's an example of comparing two functions that
take `Hash{String => Integer}`:

```ruby
# you must put it in a proc taking size so Graph::Function can increase it
generator = proc {|size| Rantly { dict(size) { [string, integer] } }
dict_comparison = Graph::Function::Comparison.new(generator)
# Comparison can take any number of Methods, but for now, 2
dict_comparison.of(method(:hash_func_one), method(:hash_func_two))
# => will output an xquartz graph
```

![comparison](spec/graph/comparison.gif)

If you want to make use of more "real" fake data, [Faker](https://github.com/stympy/faker) is also included, and can be used like so in your generators:

```ruby
# again, we need to parameterize our generator with size
faker_generator = proc {|size| Rantly(size) { call(Proc.new { Faker::Date.backward(14) }) }
graph = Graph::Function::Comparison.new(faker_generator)
graph.of(method(:custom_types))
# => will output an xquartz graph
```

![faker](spec/graph/faker.gif)

The only downside here is that you can't parameterize `Faker`, but you could use random generators to mix it up. Using the above example, `graph-function` won't pass anything into the `faker_generator` but the `size`, so if we want the value to change, we could use `Faker::Date.backward(proc { rand(10) }.call)`.

Check out the [spec file](spec/graph/function_spec.rb) to see all of these or see [examples](examples/).

### Functions that use `self`

For graphing functions that operate on `self`, such as `String#upcase`, you must provide a `Method` or `Proc` that wraps the method call. For instance:

```ruby
generator = proc {|size| Rantly { sized(size) { string } } }
# wrap the call to upcase
test_upcase = proc {|s| s.upcase }
graph = Graph::Function::Comparison.new(generator)
graph.of(test_upcase)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mooreniemi/graph-function. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Footnotes

<b id="f1">1</b> Why are we constrained to testing the same parameter types? The intent of this library is to graph _implementations_. Changing parameter types suggests a change in the _behavior_ of the function. That doesn't make for a very productive comparison. [↩](#a1)
