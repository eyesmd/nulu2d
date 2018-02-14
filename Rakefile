require 'rake/testtask'

task :default => :test

Rake::TestTask.new() do |t|
  t.test_files = FileList['test/*.rb']
  t.verbose = false
  t.warning = true
end
