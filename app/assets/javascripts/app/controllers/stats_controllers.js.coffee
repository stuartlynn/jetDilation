class App.StatsController extends Spine.Controller
  # elements:
  #   '.items': items
  # 
  # events:
  #   'click .item': 'itemClick'
  className: 'statsBox'


  constructor: ->
    super
    @render()

  render:=>
    