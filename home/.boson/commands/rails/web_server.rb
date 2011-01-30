module WebServer 
  def restart_server
    system("sudo /opt/nginx/sbin/nginx -s reload")
  end
end
