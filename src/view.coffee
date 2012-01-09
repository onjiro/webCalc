$ ->
  # 電卓のビューとなるHTMLを作成
  buttons = ""
  for line in [
    [ "7", "8", "9", "-" ],
    [ "4", "5", "6", "+" ],
    [ "1", "2", "3", "=" ],
    [ "0", "00", ".", "OK" ] ]
    do (line) ->
      htmlLine = ""
      htmlLine += "<div class=\"calcButton\">#{value}</div>" for value in line
      buttons += "<div class=\"calcLine\">#{htmlLine}</div>"
  $html = $("<div id=\"calcBoard\"><div class=\"display\">0.</div>#{buttons}</div>")
  $html.hide()
  $("body").append $html

  # 電卓の動作を各ボタンに割り当て
  $("div.calcButton", calc.$html).not(":contains(OK)").bind "click", (event) ->
    calc.calculator.entry $(this).html()
    $("#calcBoard div.display").html "#{calc.calculator.display()}."
  $("div.calcButton:contains(OK)", calc.$html).bind "click", (event) ->
    calc.removeHandlers()
    $("#calcBoard").trigger "calcDecide", calc.calculator.display()

this.calc =
  eventIds: []
  calculator: null
  start: (ondecide, oncancel) ->
    ondecide = ondecide or (event, value) ->
    oncancel = oncancel or (event, value) ->

    calc.calculator = new Calculator()
    $("#calcBoard div.display").html "#{calc.calculator.display()}."
    $("#calcBoard").show()
    calc.eventIds.push setTimeout(->
      $("body > *:not(#calcBoard)").bind "click", calc.cancel
    , 0)
    $("#calcBoard").bind("calcCancel", (event, value) ->
      oncancel event, value
      $(this).hide()
    ).bind "calcDecide", (event, value) ->
      ondecide event, value
      $(this).hide()

  cancel: ->
    calc.removeHandlers()
    $("#calcBoard").trigger "calcCancel", calc.calculator.display()

  removeHandlers: ->
    $.each calc.eventIds, (i, id) ->
      clearTimeout id

    calc.eventIds = []
    $("body > *").unbind "click", calc.cancel