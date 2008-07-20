require 'rubygems'
require 'gosu'

class Tower
  attr_accessor :x, :y
  
  def draw
  end
end

class Projectile
  attr_accessor :x, :y

  def draw
  end
end

class Enemy
  attr_accessor :x, :y, :distance

  def draw
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Tower"
    @towers = []
    @projectiles = []
    @enemies = []
  end

  def update
  end

  def draw
    (@towers + @projectiles + @enemies).each do |object|
      object.draw
    end
  end
end

window = GameWindow.new
window.show