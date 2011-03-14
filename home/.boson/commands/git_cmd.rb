module GitCmd
  def self.included(base)
    require 'uri'
    @@url =  URI.parse("ssh://user@host:port")
    @@git_dir = "root/of/all/servers"
  end

  def git_diff(filename)
    log = `git log --oneline #{filename}`
    logs = log.split("\n")
    parsed = logs.map{|a| {:sha => a[0..6], :log => a[7..-1].chomp.strip  }}
    previous = ""
    $stdout.sync = true

    parsed.each do |commit|
      str = "git diff --color #{previous} #{commit[:sha]} #{filename}"
      puts str
      system str 
      puts ""
      puts "Press enter to continue"
      STDIN.gets
      previous = commit[:sha]
      puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    end
    nil
  end

  def create_git_server(ssh_url, git_dir, remote_branch = "origin")
    url = URI.parse(ssh_url)

    cmd = %{ssh #{url.user}@#{url.host} -p #{url.port} "mkdir #{git_dir} && cd #{git_dir} && git init"}
    system  cmd
    cmd = %{git remote add origin ssh://#{url.user}@#{url.host}:#{url.port}#{git_dir}}
    system cmd
    cmd = %{git push #{remote_branch} master}
    system cmd
  end

  def list_repos
    cmd = %{ssh #{@@url.user}@#{@@url.host} -p #{@@url.port} "ls #{@@git_dir}"} 
    system cmd
  end
end
