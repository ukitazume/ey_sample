require 'rubygems'
require 'bundler'
Bundler.setup(:default, Rails.env)
require 'lingman'

Lingman::Updater.update(
  "opsbot", # BOT ID
  "ukitazume_devops", # ROOM ID
  "qpvSFIDy9r06qFqc7Lr5K9bWQ0f", # SECRET
  "#{app} / #{revision} is deployed #{environment_name} by #{deployed_by}."
)

