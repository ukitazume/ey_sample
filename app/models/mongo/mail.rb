class Mail
  @@coll = $mongo_db[self.name.underscore.pluralize]

  def self.set(body)
    @@coll.insert({body: body, created_at: Time.now})
  end

  def self.tail
    @@coll.find({}, {:limit => 20, :sort => ['created_at', Mongo::DESCENDING]})
  end

  def self.count
    @@coll.count rescue 0
  end
end
