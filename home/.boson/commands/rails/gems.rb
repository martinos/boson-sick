module Gems

  # @options :version => :string
  def dependency_tree(gem_reg_ex, options = {})
    dep = Gem::Dependency.new(gem_reg_ex, options[:version] || ">=0")
    Gem.source_index.search(dep).map{|spec| dependency_tree_viewer(spec) }.to_yaml
  end
private
  def dependency_tree_viewer(spec)
    if spec.dependencies.empty?
      return {"#{spec.name} (#{spec.version.to_s})" => nil}
    else
      childs = spec.dependencies.select{|a| a.type == :runtime}.map do |dep|
        dependency_tree_viewer(Gem.source_index.search(dep).first)
      end
      {"#{spec.name} (#{spec.version.to_s})" => childs}
    end
  rescue
    puts spec.name
    puts spec.version.to_s
    raise
  end
  
end
