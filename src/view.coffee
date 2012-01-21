$calcBoard = null
$ ->
  # 電卓のビューとなるHTMLを作成
  htmlButtons = ""
  for line in [
    [ "7", "8", "9", "-" ],
    [ "4", "5", "6", "+" ],
    [ "1", "2", "3", "=" ],
    [ "0", "00", ".", "OK" ] ]
    do (line) ->
      htmlLine = ""
      htmlLine += "<div class=\"calcButton\" data-value=\"#{value}\">#{value}</div>" for value in line
      htmlButtons += "<div class=\"calcLine\">#{htmlLine}</div>"
  htmlDisplay = "<div class=\"display\">0.</div>"
  $("body").append $calcBoard = $("<div id=\"calcBoard\">#{htmlDisplay}#{htmlButtons}</div>").hide()
  $calcBoard.display = (value) -> $calcBoard.find(".display").html(value).end()

  # 電卓の動作を各ボタンに割り当て
  $calcButtons = $calcBoard.find("div.calcButton")
  $calcButtons.not(":contains(OK)").bind "vclick", (event) ->
    $calcBoard.display "#{calculator.entry($(this).text()).display()}."
  $calcButtons.filter(":contains(OK)").bind "vclick", (event) ->
    cancelHandlers.remove()
    $calcBoard.trigger "calcDecide", calculator.display()

  # 各ボタンの押下時に active クラスを付加
  $calcButtons.bind "vmousedown", (event)-> $(this).addClass "active"
  $calcButtons.bind "vmouseup", (event)-> $(this).removeClass "active"

calculator = null
cancelHandlers = (->
  eventIds = []
  return {
    # 直接 cancel をバインドすると、直後に cancel が発動してしまうため setTimeout で間接的にバインドする
    add: ->
      eventIds.push setTimeout((-> $("body > *:not(#calcBoard)").bind "vclick", calc.cancel), 0)
    remove: ->
      clearTimeout id for id in eventIds
      eventIds = []
      $("body > *").unbind "vclick", calc.cancel
  }
).call()

# クライアントから使用されるAPIを定義
this.calc =
  start: (ondecide, oncancel) ->
    ondecide = ondecide or (event, value) ->
    oncancel = oncancel or (event, value) ->
    calculator = new Calculator()

    cancelHandlers.add()
    $calcBoard.display("#{calculator.display()}.").show().
    bind("calcCancel", (event, value) ->
      oncancel event, value
      $(this).hide()
    ).bind "calcDecide", (event, value) ->
      ondecide event, value
      $(this).hide()

  cancel: ->
    cancelHandlers.remove()
    $calcBoard.trigger "calcCancel", calculator.display()

