module HamlConverter
  def self.included(mod)
    require 'haml'
    require "haml/html"
  end

  def convert_all_erb_to_haml 
    Dir["*.erb"].each do |filename|
      erb = File.read(filename)
      filename =~ /(.*)\.erb/
      haml_file_name = $1 + ".haml"
      File.open(haml_file_name, "w") {|f| f << Haml::HTML.new(erb, :erb => true).render}
      File.delete(filename)
    end
  end
end
