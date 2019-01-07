require 'rake/testtask'

task :default => :test

Rake::TestTask.new() do |t|
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = false
  t.warning = true
end

task :collision do
  ruby "./test/sandbox_collision.rb"
end

task :sandbox do
  ruby "./test/sandbox_world.rb"
end
