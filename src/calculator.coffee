this.Calculator = ->
  # Calculator のステートを表す定数
  MODE = {
    ACCUMULATING: 0,
    OPERATOR_SETTED: 1,
    EVALUATED: 2,
  }
  currentMode = MODE.OPERATOR_SETTED
  accumulator = "0"
  incoming = "0"
  operator = null
  constants = null

  return calculator =
    display: -> return (if currentMode is MODE.ACCUMULATING then incoming else accumulator)
    operator: -> return operator
    entry: (value) ->
      respondTo value for respondTo in [
        ((value) ->
          return  unless value.match(/[0-9]/)
          incoming = (if (currentMode is MODE.ACCUMULATING) then incoming + value else value)
          currentMode = MODE.ACCUMULATING
        ),
        ((value) ->
          return  unless value.match(/[\+\-\*\/]/)
          constants = null
          calculator.entry("=").entry value  if currentMode is MODE.ACCUMULATING
          operator = value
          currentMode = MODE.OPERATOR_SETTED
        ),
        ((value) ->
          return  unless value.match("=")
          if not operator and constants
            accumulator = incoming
            operator = constants.operator
            incoming = constants.value
          if operator
            constants = {
              operator: operator
              value: (if (operator is "*") then accumulator else incoming)
            }
            accumulator = eval(accumulator + operator + incoming).toString()
          else
            accumulator = incoming
          operator = null
          currentMode = MODE.EVALUATED
        )]
      return this
