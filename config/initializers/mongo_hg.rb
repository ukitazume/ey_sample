db_name = "#{Rails.application.class.parent_name.underscore}_#{Rails.env}"
mongohq_connection_uri = case Rails.env
                         when 'production' then EY::Config.get(:mongohq, 'MONGOHQ_URL') rescue nil
                         when 'staging' then EY::Config.get(:mongohq, 'MONGOHQ_URL') rescue nil
                         else "mongodb://localhost:27017/#{db_name}"
                         end
# default connect test db,,,
db_name = mongohq_connection_uri.split('/').last
$mongo_client = Mongo::Connection.from_uri mongohq_connection_uri
$mongo_db = $mongo_client[db_name]
