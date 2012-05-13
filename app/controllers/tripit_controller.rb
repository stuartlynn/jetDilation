class TripitController < ApplicationController
  # before_filter :authenticate_user!
  before_filter :get_consumer_info, :except => [ :index ]

  def index
    session[:request_token] = nil
  end

  def tripit
    gem 'oauth'
    require 'oauth/consumer'
    session[:request_token] = nil

    @api_key ='d75e617cadf0472a8fa1e758ef7c2754a68bd2b6'
    @api_secret="18901feed6c02839a4b049844e9f12d947da97fe"

    consumer = OAuth::Consumer.new @api_key, @api_secret, { :site => "https://api.tripit.com" }
    callback = CGI::escape("http:0.0.0.0:3000/tripit_callback")
        
    request_token = consumer.get_request_token
    puts "request token is  #{request_token}"
    oauth_token = request_token.token
    
    request_url = "https://www.tripit.com/oauth/authorize?oauth_token=#{oauth_token}&oauth_callback=#{callback}"
    request_token.consumer.secret = nil # do not pass the consumer secret via session
    
    session[:request_token] = request_token

    redirect_to request_url
  end

  def trip_it_profile 
    access_token  = JSON.parse(session[:access_token])
    @client.authorize_from_access(access_token['token'], access_token['secret'])
    user = TripIt::Profile.new(@client)
    
    username = user.public_display_name
    flights = []

    trips = user.trips(:include_objects => true, :past=>true)
    flights = []
    trips.each do |trip|
      trip.air.each do |air|
        air.segment.each do |seg|
          flights << {
              start_lat:seg.start_airport_latitude, 
              end_lat: seg.end_airport_latitude,
              start_lng:seg.start_airport_longitude, 
              end_lng: seg.end_airport_longitude,
              distance: seg.distance.gsub(/\D/,"").to_f ,
              distance_raw: seg.distance,
              start_raw: seg.start_date_time,
              end_raw: seg.end_date_time,
              duration: seg.duration.split(",")[0].gsub(/\D/,"").to_f*60.0*60.0 + seg.duration.split(",")[1].gsub(/\D/,"").to_f*60.0,
              duration_raw: seg.duration
              
            }
        end
      end
    end

    trips = user.trips(:include_objects => true, :past=>false)
    trips.each do |trip|
      trip.air.each do |air|
        air.segment.each do |seg|
          flights << {
               start_lat:seg.start_airport_latitude, 
              end_lat: seg.end_airport_latitude,
              start_lng:seg.start_airport_longitude, 
              end_lng: seg.end_airport_longitude,
              distance: seg.distance.gsub(/\D/,"").to_f ,
              distance_raw: seg.distance,
              start_raw: seg.start_date_time,
              end_raw: seg.end_date_time,
              duration: seg.duration.split(",")[0].gsub(/\D/,"").to_f*60.0*60.0 + seg.duration.split(",")[1].gsub(/\D/,"").to_f*60.0,
              duration_raw: seg.duration
            }
        end
      end
    end
    respond_to do |format|
      format.json { render :json => { flights: flights, username: username } }
    end
  end

  def logout 
    session[:request_token] = nil
    session[:access_token] = nil
    redirect_to '/'
  end

  def tripit_callback

    request_token = session[:request_token]
    request_token.consumer.secret = @api_secret

    session[:request_token] = nil

    access_token = request_token.get_access_token.to_json
    session[:access_token] = access_token

    puts "HAVE ACCESS TOKEN #{access_token}"
    # TODO 
    # STORE access_token and access_token_secret in DB
    flash[:notice] = "Successfully authenticated TripIt!"
    redirect_to '/results'
  end

  
  private
  
  def get_consumer_info
    @api_key = "d75e617cadf0472a8fa1e758ef7c2754a68bd2b6"
    @api_secret = "18901feed6c02839a4b049844e9f12d947da97fe"
    @client = TripIt::OAuth.new(@api_key,  @api_secret)

  end

end