require 'rake/testtask'

task :default => :test

Rake::TestTask.new() do |t|
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = false
  t.warning = true
end

task :sandbox, [:option] do |t, args|
  Dir.chdir("./test/sandbox/") do
    filenames = Dir.glob("sandbox_*.rb")
    selected_sandbox = args[:option] ? args[:option].to_i : nil

    if selected_sandbox
      if selected_sandbox >= 1 && selected_sandbox <= filenames.size()
        begin
          eval("ruby '#{filenames[selected_sandbox-1]}'")
        rescue Exception
        end
      else
        puts "Invalid sandbox index"
      end
    else
      puts "Available sandboxes..."
      filenames.each_with_index{ |filename, i| puts " #{i+1} - #{filename}" }
    end
  end
end
