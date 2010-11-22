module GemTask
  def show_repository
    dirnames =  Dir["*"].select{|a| File::directory?(a)}

    gem_to_git = dirnames.map do |dir|
      { :gem => dir, :url => 
        Dir.chdir(dir) do
          `git config --get remote.origin.url`.chomp
        end
      }
    end.to_yaml

    File.open("git_gems.yml", "w") << gem_to_git 
  end
end
