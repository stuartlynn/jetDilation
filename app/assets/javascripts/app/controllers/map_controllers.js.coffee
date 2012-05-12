class App.MapController extends Spine.Controller

  constructor: ->
    super 
    @append("<div id='mainMap'></div>")
    setTimeout @setUpMap, 100
    # @loadRegions()

  setUpMap:=>
    @leafletMap = new L.Map('mainMap')

    @cloudmade = new L.TileLayer 'http://{s}.tile.cloudmade.com/703a104d15d44e2885f6cedeaaec6d30/60297/256/{z}/{x}/{y}.png'
      maxZoom: 18

    @leafletMap.setView new L.LatLng(51.505, -0.09), 5
    @leafletMap.addLayer(@cloudmade)