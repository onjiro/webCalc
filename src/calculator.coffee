this.Calculator = ->
  # Calculator のステートを表す定数
  MODE = {
    ACCUMULATING: 0,
    OPERATOR_SETTED: 1,
    EVALUATED: 2,
  }
  mode = MODE.OPERATOR_SETTED
  current = {
    accumulator: "0",
    incoming: "0",
    operator: null,
  }
  operator = null
  constants = null

  return calculator =
    display: -> return (if mode is MODE.ACCUMULATING then current.incoming else current.accumulator)
    operator: -> return current.operator
    entry: (value) ->
      respondTo value for respondTo in [
        ((value) ->
          return  unless value.match(/[0-9]/)
          current.incoming = (if (mode is MODE.ACCUMULATING) then current.incoming + value else value)
          mode = MODE.ACCUMULATING
        ),
        ((value) ->
          return  unless value.match(/[\+\-\*\/]/)
          constants = null
          calculator.entry("=").entry value  if mode is MODE.ACCUMULATING
          current.operator = value
          mode = MODE.OPERATOR_SETTED
        ),
        ((value) ->
          return  unless value.match("=")
          if not current.operator and constants
            current.accumulator = current.incoming
            current.operator = constants.operator
            current.incoming = constants.value
          if current.operator
            constants = {
              operator: current.operator
              value: (if (current.operator is "*") then current.accumulator else current.incoming)
            }
            current.accumulator = eval(current.accumulator + current.operator + current.incoming).toString()
          else
            current.accumulator = current.incoming
          current.operator = null
          mode = MODE.EVALUATED
        )]
      return this
