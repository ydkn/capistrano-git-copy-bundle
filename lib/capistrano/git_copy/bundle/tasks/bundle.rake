def git_copy_bundle_utility
  @_git_copy_bundle_utility ||= Capistrano::GitCopy::Bundle::Utility.new(self)
end

namespace :load do
  task :defaults do
    set :bundle_flags, "#{fetch(:bundle_flags)} --local"
  end
end

namespace :git_copy do
  namespace :bundle do
    task upload: :'git_copy:bundle:cache' do
      on release_roles :all do
        git_copy_bundle_utility.upload
      end
    end

    desc 'Cache bundled gems'
    task :cache do
      run_locally do
        git_copy_bundle_utility.cache
      end
    end

    desc 'Clear bundle cache'
    task :clear do
      run_locally do
        git_copy_bundle_utility.clear_local
      end

      on release_roles :all do
        git_copy_bundle_utility.clear_remote
      end
    end
  end
end


before 'bundler:install', 'git_copy:bundle:upload'
