module ApplicationHelper
  def clc_image_tag(name)
    case Rails.env
    when 'production', 'staging'
      cl_image_tag('sample.png')
    else
      'only production'
    end
  end
end
