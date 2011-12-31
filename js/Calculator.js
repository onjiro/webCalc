Calculator = function() {
    // 評価結果を溜めるスタック
    var accumulator = "0";
    // 数値の入力を受け取るスタック
    var incoming = "0";
    // 現在の計算モード
    var operator = "";
    // 直前に評価が行われたかどうか
    var evaluatedJustBefore = true;
    
    return {
        // 現在の表示部を返す
        display: function() {
            return evaluatedJustBefore ? accumulator: incoming; 
        },
        // 現在の計算モードを返す
        operator: function() {
            return operator;
        },
        // 計算機への入力を行う
        entry: function(value) {
            if (value.match(/[0-9]/)) {
                if (evaluatedJustBefore) {
                    incoming = value;
                } else {
                    incoming += value;
                }
                evaluatedJustBefore = false;
            } else if (value.match(/[\+\-\*\/]/)) {
                if (operator !== "") {
                    accumulator = eval("return " + accumulator + operator + incoming);
                } else {
                    accumulator = incoming;
                }
                operator = value;
                evaluatedJustBefore = true;
            } else if (value.match(/=/)) {
                if (operator !== "") {
                    accumulator = eval(accumulator + operator + incoming).toString();
                } else {
                    accumulator = incoming;
                }
                evaluatedJustBefore = true;
            }
            return this;
        },
    };
};