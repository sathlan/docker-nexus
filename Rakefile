require 'rake'
require 'rspec/core/rake_task'

task :spec    => 'spec:all'
task :default => :spec

namespace :spec do
  targets = []
  Dir.glob('./spec/*').each do |dir|
    next unless File.directory?(dir)
    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    original_target = target == "_default" ? target[1..-1] : target
    desc "Run serverspec tests to #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = original_target
      ENV['USE_DOCKER'] = 'yes' if original_target != 'localhost'
      t.pattern = "spec/#{original_target}/*_spec.rb"
    end
  end
end

desc 'Prepare release'
task :prep_release do
  sh 'chag entries'
  sh 'chag contents'
  STDOUT.puts 'What version ? '
  input = STDIN.gets.chomp
  sh "chag update ${input}"
  sh 'chag tag'
end
