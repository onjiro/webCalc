this.Calculator = ->
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
        ),
        ((value) ->
          return  unless value.match(/[\+\-\*\/]/)
          constants = null
          calculator.entry("=").entry value if current.incoming
          current.operator = value
        ),
        ((value) ->
          return  unless value.match("=")
          current.incoming = current.incoming or current.accumulator
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
        )]
      return this
