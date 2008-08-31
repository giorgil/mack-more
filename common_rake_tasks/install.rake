desc "Install the gem"
task :install => [:rerdoc, :package] do |t|
  sudo = ENV['SUDOLESS'] == 'true' || RUBY_PLATFORM =~ /win32|cygwin/ ? '' : 'sudo'
  puts `#{sudo} gem install --local --pkg/#{@gem_spec.name}-#{@gem_spec.version}.gem`
end