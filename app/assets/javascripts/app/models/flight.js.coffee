class App.Flight extends Spine.Model
  @configure 'Flight', 'distance', 'duration','duration_raw', 'end_lat', 'end_lng', 'start_lat', 'start_lng'

  @fetch:->
    $.getJSON '/profile.json', (data)=>
      Spine.trigger('gotName', data.username)
      for flight in data.flights
        App.Flight.create(flight)


  timeShiftLorentz:=>
    v = @distance*1609.344 / @duration
    vc  = v / 299792458.0
    t0 = @duration
    console.log v, t0 , 1.0 - (vc * vc)
    @duration - @duration * Math.sqrt( 1.0 / ( 1.0 - (vc * vc) )) 

  timeShiftGravity:=>
    t = @duration
    r0 = 0.0088/1000.0
    @height = 9144
    t-t*Math.sqrt(1-r0/@height)