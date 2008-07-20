require 'rubygems'
require 'gosu'

$: << 'lib'
require 'window'

window = GameWindow.new(10, 10)
window.show