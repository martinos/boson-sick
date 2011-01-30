module GitCmd
  def gitdiff(filename)
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
end
