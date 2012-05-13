class HomeController < ApplicationController
  
  def results 
  end

  def index
  end

  def flights 
    @tripit ||= TripIt::OAuth.new('0b048eef3d519b533850ddcb6be9356db5c069a6', '5b97691f918b722a52e425ecd97257cc2b067679')
    
  end
end
