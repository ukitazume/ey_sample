class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:mail]
  def index
  end

  def add_ons
    @access_tail = Access.tail
    @access_count = Access.count
  end

  def mail
    Mail.set(params)
    render :text => 'ok', :status => 200
  end

  def mail_list
    @mail_list = Mail.tail
  end
end

