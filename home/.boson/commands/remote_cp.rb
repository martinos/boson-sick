module RemoteCp

  def rmcp(filename = nil)
    if filename == nil
      basename = "anonymous"
      content = $stdin.read
    else
      full_path = File.expand_path(filename)
      basename = File.basename(full_path)

      content = File.open(full_path)
    end
    s3_connect


    S3Object.store("file_name.txt", basename, 'RemoteClipboard')
    S3Object.store("content", content, 'RemoteClipboard')
  end

  def rmp
    s3_connect

    file_name = S3Object.find("file_name.txt", 'RemoteClipboard').value

    if File.exist?(file_name)
      puts "#{file_name} already exist."
      print "Do you want to replace it (y/n)? "
      res = $stdin.gets.chomp
      return unless res == "y"
    end

    content = S3Object.find('content', 'RemoteClipboard').value
    File.open(file_name, "w+") {|f| f << content}
    puts "#{file_name} copied."
  end

  def rmfn
    rm_filename
  end

  def rmcat
    rm_content
  end

private
  def s3_connect
    require 'aws/s3'
    include AWS::S3
    AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['AMAZON_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
    )
  end

  def rm_filename
    s3_connect
    file_name = S3Object.find("file_name.txt", 'RemoteClipboard').value
  end

  def rm_content
    s3_connect
    content = S3Object.find( 'content', 'RemoteClipboard').value
  end
end
