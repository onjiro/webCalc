Calculator = ->
  MODE_ACCUMULATING = 0
  MODE_OPERATOR_SETTED = 1
  MODE_EVALUATED = 2
  currentMode = MODE_OPERATOR_SETTED
  accumulator = "0"
  incoming = "0"
  operator = null
  constantOperator = null
  constantValue = null
  responses = [
    (value) ->
      return  unless value.match(/[0-9]/)
      incoming = (if (currentMode is MODE_ACCUMULATING) then incoming + value else value)
      currentMode = MODE_ACCUMULATING
    , (value) ->
      return  unless value.match(/[\+\-\*\/]/)
      constantOperator = constantValue = null
      calculator.entry("=").entry value  if currentMode is MODE_ACCUMULATING
      operator = value
      currentMode = MODE_OPERATOR_SETTED
    , (value) ->
      return  unless value.match("=")
      if not operator and constantOperator and constantValue
        accumulator = incoming
        operator = constantOperator
        incoming = constantValue
      if operator
        constantOperator = operator
        constantValue = (if (operator is "*") then accumulator else incoming)
        accumulator = eval(accumulator + operator + incoming).toString()
      else
        accumulator = incoming
      operator = null
      currentMode = MODE_EVALUATED
  ]
  return calculator =
    display: ->
      (if currentMode is MODE_ACCUMULATING then incoming else accumulator)

    operator: ->
      operator

    entry: (value) ->
      i = 0
      while i < responses.length
        responses[i] value
        i++
      this
