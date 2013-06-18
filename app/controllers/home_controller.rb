class HomeController < ApplicationController
  def index
    Access.set(request)
  end

  def add_ons
  end
end
