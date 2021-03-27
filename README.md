# DockerDirEnv

I am using docker containers for development of a rails app as well as the environmental credentials. I figured that I'm adding the same three files to all of my projects. Since I have a bunch of existing projects a custom template is not an option. So I went with a gem and a generator instead.

I am pretty inexperienced with gem development. Tips are very welcome!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docker_dir_env'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker_dir_env

## Usage

Run the installer:
```
rails g docker_dir_env:install
```

Provide credentials (`EDITOR=vim rails credentials:edit`) with the following structure:
```
database:
  username: YOUR_USERNAME
  password: YOUR_PASSWORD
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BedeDD/docker_dir_env.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
