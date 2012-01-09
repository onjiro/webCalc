this.Calculator = ->
  # Calculator のステートを表す定数
  MODE = {
    ACCUMULATING: 0,
    OPERATOR_SETTED: 1,
    EVALUATED: 2,
  }
  mode = MODE.OPERATOR_SETTED
  current = {
    accumulator: null,
    incoming: null,
    operator: null,
  }
  constants = null

  return calculator =
    display: -> return current.incoming || current.accumulator || "0"
    operator: -> return current.operator
    entry: (value) ->
      respondTo value for respondTo in [
        ((value) ->
          return  unless value.match(/[0-9]/)
          current.incoming = (current.incoming || "") + value
          mode = MODE.ACCUMULATING
        ),
        ((value) ->
          return  unless value.match(/[\+\-\*\/]/)
          constants = null
          calculator.entry("=").entry value if mode is MODE.ACCUMULATING
          current.operator = value
          mode = MODE.OPERATOR_SETTED
        ),
        ((value) ->
          return  unless value.match("=")
          if not current.operator and constants
            current = {
              accumulator: (constants.accumulator if constants.operator is "*") || current.incoming,
              operator: constants.operator,
              incoming: (constants.incoming unless constants.operator is "*") || current.incoming,
            }
          if current.operator
            constants = current
            current = {
              accumulator: eval(current.accumulator + current.operator + current.incoming).toString(),
              incoming: null,
              operator: null,
            }
          else
            current = {
              accumulator: current.incoming || "0"
              incoming: null,
              operator: null,
            }
          mode = MODE.EVALUATED
        )]
      return this
