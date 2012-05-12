class App.MapController extends Spine.Controller

  constructor: ->
    super 
    @append("<div id='mainMap'></div>")
    @setUpMap()
    @loadRegions()

  setUpMap:->
    @leafletMap = new L.Map('mainMap')

    @cloudmade = new L.TileLayer 'http://{s}.tile.cloudmade.com/703a104d15d44e2885f6cedeaaec6d30/60297/256/{z}/{x}/{y}.png'
      maxZoom: 18
    @leafletMap.addLayer(@cloudmade)