module StatsTasks
  def stats
    STDIN.inject({:count => 0, :min => nil, :max => nil, :sum => 0}) do |stats, line|
      num = line.to_f
      stats[:min] ||= num
      stats[:max] ||= num
      stats[:min] = num if num < stats[:min]
      stats[:max] = num if num > stats[:max]
      stats[:sum] += num
      stats[:count] += 1
      stats
    end
  end
end
