require 'digest/md5'
require 'capistrano/bundler'
require 'capistrano/git_copy'

load File.expand_path('../bundle/tasks/bundle.cap', __FILE__)
