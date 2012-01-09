$calcBoard = null
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
  $("body").append $calcBoard = $("<div id=\"calcBoard\"><div class=\"display\">0.</div>#{buttons}</div>").hide()
  $calcBoard.display = (value) -> $calcBoard.find(".display").html(value).end()

  # 電卓の動作を各ボタンに割り当て
  $calcButtons = $calcBoard.find("div.calcButton")
  $calcButtons.not(":contains(OK)").bind "click", (event) ->
    $calcBoard.display "#{calculator.entry($(this).html()).display()}."
  $calcButtons.filter(":contains(OK)").bind "click", (event) ->
    removeHandlers()
    $calcBoard.trigger "calcDecide", calculator.display()

calculator = null
eventIds = []
removeHandlers = ->
  $.each eventIds, (i, id) -> clearTimeout id
  eventIds = []
  $("body > *").unbind "click", calc.cancel

# クライアントから使用されるAPIを定義
this.calc =
  start: (ondecide, oncancel) ->
    ondecide = ondecide or (event, value) ->
    oncancel = oncancel or (event, value) ->
    calculator = new Calculator()

    # 直接 cancel をバインドすると、直後に cancel が発動してしまうため setTimeout で間接的にバインドする
    eventIds.push setTimeout((-> $("body > *:not(#calcBoard)").bind "click", calc.cancel), 0)
    $calcBoard.display("#{calculator.display()}.").show().
    bind("calcCancel", (event, value) ->
      oncancel event, value
      $(this).hide()
    ).bind "calcDecide", (event, value) ->
      ondecide event, value
      $(this).hide()

  cancel: ->
    removeHandlers()
    $calcBoard.trigger "calcCancel", calculator.display()

