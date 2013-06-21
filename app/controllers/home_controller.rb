class HomeController < ApplicationController
  def index
    Access.set(request)
  end

  def add_ons
    @access_tail = Access.tail
    @access_count = Access.count
  end
end
