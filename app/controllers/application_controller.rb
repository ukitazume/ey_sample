class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :assign_access

  private
  def assign_access
    @access_tail = Access.tail
    @access_count = Access.count
  end
end
