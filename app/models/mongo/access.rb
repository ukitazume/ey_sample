class Access
  @@coll = $mongo_db[self.name.underscore]

  def self.be_capped
    unless $mongo_db.eval("db.#{@@coll.name}.isCapped()")
      $mongo_db.eval("db.runCommand({\"convertToCapped\": \"#{@@coll.name}\", size: 100000});")
    end
  end

  def self.set(request)
    be_capped
    @@coll.insert({remote_host: request.env['REMOTE_HOST'], created_at: Time.now})
  end

  def self.tail
    @@coll.find({}, {:limit => 20, :sort => ['created_at', Mongo::DESCENDING]})
  end

  def self.count
    @@coll.count rescue 0
  end
end
