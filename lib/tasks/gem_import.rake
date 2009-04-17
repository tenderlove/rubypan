desc "Imports gems from a remote repository's Marshal.4.8 into a fresh DB"
task :import_gems => [:environment] do
  unless ENV['MARSHAL_SPEC']
    require 'tempfile'
    Dir.chdir(Dir::tmpdir) do
      url = 'http://gems.rubyforge.org/Marshal.4.8'
      system("wget #{url} || curl -O #{url}")
    end
    ENV['MARSHAL_SPEC'] = File.join(Dir::tmpdir, 'Marshal.4.8')
  end

  Release.import(ENV['MARSHAL_SPEC'])
end
