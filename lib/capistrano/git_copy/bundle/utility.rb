require 'capistrano/git_copy/utility'

module Capistrano
  module GitCopy
    module Bundle
      # Utility stuff to avoid cluttering of bundle.cap
      class Utility < ::Capistrano::GitCopy::Utility
        # Cache used gems
        #
        # @return void
        def cache
          local_vendor_path = File.join(repo_path, 'vendor')

          execute(:mkdir, '-p', local_cache_path)  unless test!("[ -d #{local_cache_path} ]")
          execute(:mkdir, '-p', local_vendor_path) unless test!("[ -d #{local_vendor_path} ]")

          execute(:ln, '-s', local_cache_path, File.join(repo_path, 'vendor', 'cache'))

          if gems_changed?
            Bundler.with_clean_env do
              execute("bundle package --gemfile #{File.join(repo_path, 'Gemfile')} --all --all-platforms")
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

          execute(:ln, '-s', remote_cache_path, File.join(release_path, 'vendor', 'cache'))

          remote_gems = capture(:ls, remote_cache_path).split(/\s+/)

          (local_gems - remote_gems).each do |file|
            upload!(File.join(local_cache_path, file), File.join(remote_cache_path, file), recursive: true)
          end
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
          File.join(tmp_path, 'bundle_cache')
        end

        # MD5 sum of Gemfile.lock to deploy
        #
        # @return [String]
        def gemfile_md5
          @_gemfile_md5 ||= Digest::MD5.file(File.join(repo_path, 'Gemfile.lock')).hexdigest rescue nil
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
          File.join(tmp_path, 'git_copy_bundle_gemfile_lock.md5')
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
      end
    end
  end
end
