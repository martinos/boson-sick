# # View class needs to come before enable()
class Hirb::Helpers::Yaml; def self.render(output, options={}); output.to_yaml; end ;end
Hirb.enable

