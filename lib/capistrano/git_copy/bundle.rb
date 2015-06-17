require 'digest/md5'
require 'capistrano/bundler'
require 'capistrano/git_copy/bundle/utility'

load File.expand_path('../bundle/tasks/bundle.cap', __FILE__)
