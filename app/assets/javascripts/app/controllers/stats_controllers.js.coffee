class App.StatsController extends Spine.Controller
  
  elements:
    "#spaceStat .stats_val" : "spaceStat"
    "#timeStat  .stats_val" : "timeStat"
    "ul" : 'stats'
    "#personName" : "name"
    "h1" : "head"
  # 
  # events:
  #   'click .item': 'itemClick'
  className: 'statsBox'


  constructor: ->
    super
    @render()
    App.Flight.bind("create", @addFlight)
    Spine.bind("gotName", @updateName)
    @totalDist = 0
    @time = 0
    @distToMoon = 238855.0

  updateName:(username)=>
    @name.html username
    @head.fadeIn()

  addFlight:(flight)=>
    console.log flight
    @totalDist += flight.distance
    console.log flight.timeShiftLorentz() ,flight.timeShiftGravity()
    @time  += (flight.timeShiftLorentz() + flight.timeShiftGravity())*1000000

    @spaceStat.html "#{ (@totalDist*100.0 / @distToMoon).toFixed(2) } %"
    @timeStat.html @time.toFixed(2)
    @stats.fadeIn()

  render: =>
    @append @view('statsBox')()