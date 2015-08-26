[![Gem Version](https://img.shields.io/gem/v/capistrano-git-copy-bundle.svg)](https://rubygems.org/gems/capistrano-git-copy-bundle)
[![Dependencies](https://img.shields.io/gemnasium/ydkn/capistrano-git-copy-bundle.svg)](https://gemnasium.com/ydkn/capistrano-git-copy-bundle)
[![Code Climate](https://img.shields.io/codeclimate/github/ydkn/capistrano-git-copy-bundle.svg)](https://codeclimate.com/github/ydkn/capistrano-git-copy-bundle)

[![Join the chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ydkn/capistrano-git-copy-bundle)


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
require 'capistrano/git_copy/bundle'
```

## Usage

Packaging and uploading will happen automatically.

If you are required to package your gems before the actual deploy (e.g. using a VPN without internet access) it is possible to run the following task to prefetch the gems so it won't run on deploy:

```
$ cap production git_copy:bundle:cache
```

If you want to clear the local and remote gem cache you can run:

```
$ cap production git_copy:bundle:clear
```

## Known issues

* Currently it is not possible to package all platform versions of a gem (https://github.com/bundler/bundler-features/issues/4). However, gems can be added manually to `<shared_path>/bundle/cache`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
