require 'rubygems'
require 'bundler/setup'
require 'json', "1.8.0"
require 'tinder'

campfire = Tinder::Campfire.new '473d191d', :token => '8bdd447ce9660a31941922d48ab4862807db49c5'

room = campfire.find_room_by_id '566129'
room.speak "#{revision} is deployed #{environment_name} by #{deployed_by}."
