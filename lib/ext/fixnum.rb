class Fixnum
  def seconds_to_minutes
    mins = (self/60).to_s
    seconds = self % 60
    seconds = seconds < 10 ? "0#{seconds}" : seconds
    "#{mins}:#{seconds}"
  end
end
