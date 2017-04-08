require 'fileutils'
require 'digest/md5'

module Capistrano
  module GitCopy
    module Bundle
      # Utility stuff to avoid cluttering of bundle.rake
      class Utility
        def initialize(context)
          @context = context
        end

        # Cache used gems
        #
        # @return void
        def cache
          execute(:mkdir, '-p', local_cache_path)  unless test!("[ -d #{local_cache_path} ]")

          if gems_changed?
            Bundler.with_clean_env do
              execute("bundle package --gemfile #{File.join(Dir.pwd, 'Gemfile')} --all --all-platforms")
            end

            File.open(cached_gemfile_md5_path, 'w') { |f| f.write(gemfile_md5) } unless gemfile_md5.nil?
          end
        end

        # Upload cached gems
        #
        # @return void
        def upload
          vendor_path = File.join(release_path, 'vendor')

          execute(:mkdir, '-p', remote_cache_path) unless test!("[ -d #{remote_cache_path} ]")
          execute(:mkdir, '-p', vendor_path)       unless test!("[ -d #{vendor_path} ]")

          execute(:ln, '-s', remote_cache_path, File.join(vendor_path, 'cache'))

          remote_gems = capture(:ls, remote_cache_path).split(/\s+/)

          (local_gems - remote_gems).each do |file|
            upload!(File.join(local_cache_path, file), File.join(remote_cache_path, file), recursive: true)
          end
        end

        # Clear local cached gems
        #
        # @return void
        def clear_local
          execute(:rm, '-rf', File.join(local_cache_path, '*')) if test!("[ -d #{local_cache_path} ]")

          File.unlink(cached_gemfile_md5_path)
        end

        # Clear remote cached gems
        #
        # @return void
        def clear_remote
          execute(:rm, '-rf', File.join(remote_cache_path, '*')) if test!("[ -d #{remote_cache_path} ]")
        end

        # Path for remote bundle cache
        #
        # @return [String]
        def remote_cache_path
          File.join(shared_path, 'bundle', 'cache')
        end

        # Path for local bundle cache
        #
        # @return [String]
        def local_cache_path
          File.join(Dir.pwd, 'vendor', 'cache')
        end

        # MD5 sum of Gemfile.lock to deploy
        #
        # @return [String]
        def gemfile_md5
          @_gemfile_md5 ||= Digest::MD5.file(File.join(Dir.pwd, 'Gemfile.lock')).hexdigest rescue nil
        end

        # MD5 sum of Gemfile.lock for local gem cache
        #
        # @return [String]
        def cached_gemfile_md5
          @_cached_gemfile_md5 ||= File.read(cached_gemfile_md5_path) rescue nil
        end

        # Path to cache for MD5 sum of Gemfile.lock
        #
        # @return [String]
        def cached_gemfile_md5_path
          File.join(Dir.pwd, '.capistrano-git-copy-bundle-gemfile-lock.md5')
        end

        # Checks if Gemfile.lock has changed since last deploy
        #
        # @return [Boolean]
        def gems_changed?
          gemfile_md5.nil? || cached_gemfile_md5.nil? || gemfile_md5 != cached_gemfile_md5
        end

        # List of filenames for locally cached gems
        #
        # @return [Array]
        def local_gems
          %x(ls #{local_cache_path}).split(/\s+/)
        end

        private

        def fetch(*args)
          @context.fetch(*args)
        end

        def execute(*args)
          @context.execute(*args)
        end

        def capture(*args)
          @context.capture(*args)
        end

        def test!(*args)
          @context.test(*args)
        end

        def upload!(*args)
          @context.upload!(*args)
        end
      end
    end
  end
end
