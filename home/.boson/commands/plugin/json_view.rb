require 'json'
# # View class needs to come before enable()
class Hirb::Helpers::Json; def self.render(output, options={}); output.to_json; end ;end

