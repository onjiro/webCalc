Calculator = function() {
    const MODE_ACCUMULATING = 0;
    const MODE_OPERATOR_SETTED = 1;
    const MODE_EVALUATED = 2;
    
    // 現在の計算機のモード
    var currentMode = MODE_OPERATOR_SETTED;
    // 評価結果を溜めるスタック
    var accumulator = "0";
    // 数値の入力を受け取るスタック
    var incoming = "0";
    // 現在の計算モード
    var operator = "";
    // 定数計算機、計算結果の評価時に使用した定数を格納しておく
    var constantCalculator = null;
    // 直前に評価が行われたかどうか
    var evaluatedJustBefore = true;
    
    var responses = [
        function(value){
            if (!value.match(/[0-9]/)) { return; }
            if (currentMode === MODE_ACCUMULATING) {
                incoming += value;
            } else {
                incoming = value;
            }
            currentMode = MODE_ACCUMULATING;
        },
        function(value){
            if (!value.match(/[\+\-\*\/]/)) { return; }
            if (currentMode === MODE_ACCUMULATING) {
                calculator.entry("=").entry(value);
            } else {
                constantCalculator = null;
                operator = value;
            }
            currentMode = MODE_OPERATOR_SETTED;
        },
        function(value){
            if (!value.match("=")) { return; }
            if (constantCalculator) {
                accumulator = eval(incoming + constantCalculator).toString();
            } else {
                constantCalculator = (operator === "*") ? 
                    operator + accumulator:
                    operator + incoming;
                accumulator = (operator === "") ? incoming:
                    eval(accumulator + operator + incoming).toString();
            }
            currentMode = MODE_EVALUATED;
        },
    ];
    var calculator = {
        // 現在の表示部を返す
        display: function() {
            return currentMode === MODE_ACCUMULATING ? incoming: accumulator;
        },
        // 現在の計算モードを返す
        operator: function() {
            return operator;
        },
        // 計算機への入力を行う
        entry: function(value) {
            for (i = 0; i < responses.length; i++) {
                responses[i](value);
            }
            return this;
        },
    };
    return calculator;
};