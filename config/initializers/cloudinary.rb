CLOUDINARY_URL = case Rails.env
                 when 'production', 'staging' then EY::Config.get('cloudinary_url', 'CLOUDINARY_URL')
                 else ''
                 end
Cloudinary.config.cloud_name = CLOUDINARY_URL.split('@').last rescue nil
