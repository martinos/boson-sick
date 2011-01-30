module Deploy
  def self.config
    {:dependencies=>['web_server']}
  end

  def deploy
    system 'sudo git pull'
    system 'sudo git submodule update'
    system 'bundle install --without=test'
    restart_server
  end
end
