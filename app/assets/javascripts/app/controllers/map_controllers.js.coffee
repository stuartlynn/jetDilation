class App.MapController extends Spine.Controller

  constructor: ->
    super 
    @append("<div id='mainMap'></div>")
    setTimeout @setUpMap, 100
    # @loadRegions()

  setUpMap:=>
    @leafletMap = new L.Map('mainMap')
    @geoJsonLayer = new L.GeoJSON();

    window.geo = @geoJsonLayer

    @cloudmade = new L.TileLayer 'http://{s}.tile.cloudmade.com/703a104d15d44e2885f6cedeaaec6d30/60297/256/{z}/{x}/{y}.png'
      maxZoom: 18

    @leafletMap.setView new L.LatLng(0.505, 200), 2
    @leafletMap.addLayer(@cloudmade)
    @leafletMap.addLayer(@geoJsonLayer)

    App.Flight.bind 'create', @addFlight

  addFlight:(flight)=>
    @drawFlight flight


  drawFlight:(flight)=>
    start = new arc.Coord(flight.start_lng, flight.start_lat)
    end = new arc.Coord(flight.end_lng, flight.end_lat)
    gc = new arc.GreatCircle(start, end )
    line = gc.Arc(20)
    geo = line.json()
    @geoJsonLayer.addGeoJSON(geo)

