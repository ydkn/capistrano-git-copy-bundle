# Capistrano::GitCopy::Bundle

Packages gems locally and uploads them to the remote server instead of fetching them on the remote server.

## Setup

Add the library to your `Gemfile`:

```ruby
group :development do
  gem 'capistrano-git-copy-bundle', require: false, github: 'ydkn/capistrano-git-copy-bundle'
end
```

And require it in your `Capfile`:

```ruby
require 'capistrano/git/copy/bundle'
```

## Known issues

* Currently it is not possible to package all platform versions of a gem (https://github.com/bundler/bundler-features/issues/4). However, gems can be added manually to `<shared_path>/bundle/cache`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
