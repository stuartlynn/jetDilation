#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super
    
    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...
    @append new App.MapController()
    @append new App.StatsController()
    App.Flight.fetch()
    Spine.Route.setup()    

window.App = App