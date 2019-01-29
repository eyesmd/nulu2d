require 'rake/testtask'

task :default => :test

Rake::TestTask.new() do |t|
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = false
  t.warning = true
end

task :sandbox, [:option] do |t, args|
  puts ""
  Dir.chdir("./test/sandbox/") do

    filenames = Dir.glob("sandbox_*.rb")
    selected_sandbox = args[:option]

    if selected_sandbox
      run_ruby_script(filenames, selected_sandbox.to_i)
    else
      puts "Available sandboxes..."
      filenames.each_with_index{ |filename, i| puts " #{i+1} - #{filename}" }
      print "Select which sandbox to run (0 to abort): "
      option = STDIN.gets.chomp.to_i
      run_ruby_script(filenames, option)
    end
  end
  puts ""
end

def run_ruby_script(filenames, idx)
  if idx >= 1 && idx <= filenames.size()
    begin
      eval("ruby '#{filenames[idx-1]}'")
    rescue Exception
    end
  end
end
