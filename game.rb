require "bundler"
Bundler.require(:default)

$: << 'lib'
require 'window'

window = GameWindow.new(10, 10)
window.show
