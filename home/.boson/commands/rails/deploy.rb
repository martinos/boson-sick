module Deploy
  def self.config
    {:dependencies=>['web_server']}
  end

  def deploy
    system 'sudo git fetch'
    system 'sudo git diff remotes/origin/master'
    print "Do you want to continue the deployement?"
    
    if STDIN.gets.chomp == 'y'
      system 'sudo git merge remotes/origin/master'
      system 'sudo git submodule update'
      system 'bundle install --without=test'
      restart_server
    end
  end
end
