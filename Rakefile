# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'Tetris'
  app.identifier = 'org.integrallis.ios.games.tetris'
  app.icons = ['icon_iphone.png', 'icon_ipad.png', 'icon_iphone_retina.png']
  app.prerendered_icon = true
end
