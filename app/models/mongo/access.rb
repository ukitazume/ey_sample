# class Access
#   @@coll = $mongo_db[self.name.underscore.pluralize]
# 
#   def self.set(request)
#     @@coll.insert({remote_host: request.env['REMOTE_HOST'], created_at: Time.now})
#   end
# 
#   def self.tail
#     @@coll.find({}, {:limit => 20, :sort => ['created_at', Mongo::DESCENDING]})
#   end
# 
#   def self.count
#     @@coll.count rescue 0
#   end
# end
