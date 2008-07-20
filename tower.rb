require 'rubygems'
require 'gosu'

class Tower
  attr_accessor :x, :y
end

class Projectile
  attr_accessor :x, :y
end

class Enemy
  attr_accessor :x, :y, :distance
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Tower"
  end

  def update
  end

  def draw
  end
end

window = GameWindow.new
window.show