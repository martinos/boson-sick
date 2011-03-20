module RemoteCp
  def self.included(base)
    require 'zlib'
    require 'archive/tar/minitar'
    include Archive::Tar
  end

  def rmcp(filename = nil)
    type = nil
    content_type = nil 

    content = if filename.nil?
      basename = "anonymous"
      $stdin.read
    else
      full_path = File.expand_path(filename)
      basename = File.basename(full_path)
      if File.directory?(full_path)
        content_type = "application/gzip"
        io = StringIO.new("")
        tgz = Zlib::GzipWriter.new(io)
        Minitar.pack(basename, tgz)
        type = 'directory' 
        io.rewind
        io.string
      else
        type = 'file'
        File.open(full_path)
      end
    end
    s3_connect

    # I think that all this info should be included files metadata
    S3Object.store("file_name.txt", basename, 'RemoteClipboard')
    S3Object.store("content", content, 'RemoteClipboard', :content_type => content_type)
    S3Object.store("type", type, 'RemoteClipboard')
  end

  def rmp
    s3_connect

    file_name = S3Object.find("file_name.txt", 'RemoteClipboard').value
    type = S3Object.find("type", 'RemoteClipboard').value

    if File.exist?(file_name)
      puts "#{file_name} already exist."
      print "Do you want to replace it (y/n)? "
      res = $stdin.gets.chomp
      return unless res == "y"
    end
     
    content = S3Object.find('content', 'RemoteClipboard').value
    case type
    when 'file'
      File.open(file_name, "w+") {|f| f << content}
      puts "#{file_name} copied."
    when 'directory'
      tgz = Zlib::GzipReader.new(StringIO.new(content))
      Minitar.unpack(tgz, ".")
    end
  end

  def rmfn
    rm_filename
  end

  def rmcat
    rm_content
  end

  def my_command
    "http://www.google.com"
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
