Calculator = function() {
    // 評価結果を溜めるスタック
    var accumulator = "0";
    // 数値の入力を受け取るスタック
    var incoming = "0";
    // 現在の計算モード
    var operator = "";
    // 直前に評価が行われたかどうか
    var evaluatedJustBefore = true;
    
    var responses = [
        {
            matcher: /[0-9]/,
            responseTo: function(value) {
                if (evaluatedJustBefore) {
                    incoming = value;
                } else {
                    incoming += value;
                }
                evaluatedJustBefore = false;
            }
        },
        {
            matcher: /[\+\-\*\/=]/, 
            responseTo: function(value) {
                accumulator = (operator === "") ? incoming: eval(accumulator + operator + incoming).toString();
                evaluatedJustBefore = true;
                if (value !== "=") {
                    operator = value;
                }
            }
        },
    ];
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
            for (i = 0; i < responses.length; i++) {
                if (value.match(responses[i].matcher)) {
                    responses[i].responseTo(value);
                }
            }
            return this;
        },
    };
};