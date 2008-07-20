class Round
  attr_accessor :enemies_sent
  
  def initialize(window, number)
    @window = window
    @number = number
    @started = false
    @ended = false
    @enemies_sent = 0
  end
  
  def enemy_count
    2
  end
  
  def enemy_sent
    self.enemies_sent += 1
  end
  
  def all_enemies_sent?
    enemies_sent >= enemy_count
  end
  
  def start
    @started = true
  end

  def started?
    @started == true
  end
  
  def end
    @ended = true if started?
  end
  
end
