CLOUDINARY_URL = case Rails.env
                 when 'production', 'staging' then EY::Config.get('cloudinary', 'CLOUDINARY_URL')
                 else ''
                 end
Cloudinary.config.cloud_name = CLOUDINARY_URL.split('@').last rescue nil
