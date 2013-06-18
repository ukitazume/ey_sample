db_name = "#{Rails.application.class.parent_name.underscore}_#{Rails.env}"
mongohq_connection_uri = case Rails.env
           when 'production' then EY::Config.get(:mongohq, 'MONGOHQ_URL')
           when 'staging' then EY::Config.get(:mongohq, 'MONGOHQ_URL')
           else "mongodb://localhost:27017/#{db_name}"
           end
$mongo_db = Mongo::Connection.from_uri mongohq_connection_uri
