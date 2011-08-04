module BashHelper 
  def preprocess(preprocessor_command, *command)
    while filename = $stdin.gets
      filename.chomp!
      cmd = "#{preprocessor_command} #{filename} | #{command.join(' ')}"
      IO.popen(cmd, "r").each_line do |line|
        print "#{filename}: #{line}" 
      end
    end
  end
end
