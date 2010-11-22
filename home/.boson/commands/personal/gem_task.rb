module GemTask
  # = 
  def show_repository(options)
    dirnames =  Dir["*"].select{|a| File::directory?(a)}

    dirnames.map do |dir|
      Dir.chdir(dir) do
        `git config --get remote.origin.url`.chomp
      end
    end.reject{|a| a.empty?}
  end
end
