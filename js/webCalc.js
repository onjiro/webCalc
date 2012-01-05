$(function(){
    buttons = "";
    $.each([["7", "8", "9", "-"], ["4", "5", "6", "+"], ["1", "2", "3", "="], ["0", "00", ".", "OK"]], function(i, line) {
        buttons += '<div class="calcLine">';
        $.each(line, function(j, value){
            buttons += '<div class="calcButton">' + value + '</div>';
        });
        buttons += '</div>';
    });
    calc.$html = $('<div id="calcBoard" style="display: none;"><div class="display">0.</div>#{buttons}</div>'.replace("#{buttons}", buttons));
    // 各ボタンが押下された場合のイベント
    $("div.calcButton", calc.$html).not(":contains(OK)").bind("click", function(event){
        value = $(this).html();
        calc.calculator.entry(value);
        $("#calcBoard div.display").html(calc.calculator.display() + ".");
    });
    $("div.calcButton:contains(OK)", calc.$html).bind("click", function(event){
        calc.removeHandlers();
        $("#calcBoard").trigger("calcDecide", calc.calculator.display());
    });
    $("body").append(calc.$html);
});

calc = {
    eventIds: [],
    calculator: null,
    start: function(ondecide, oncancel) {
        ondecide = ondecide || function(event, value){};
        oncancel = oncancel || function(event, value){};
        calc.calculator = new Calculator();
        $("#calcBoard div.display").html(calc.calculator.display() + ".");
        $("#calcBoard").show();
        calc.eventIds.push(
            setTimeout(function(){$("body > *:not(#calcBoard)").bind("click", calc.cancel);}, 0)
        );
        $("#calcBoard").bind("calcCancel", function(event, value) {
            oncancel(event, value);
            $(this).hide();
        }).bind("calcDecide", function(event, value) {
            ondecide(event, value);
            $(this).hide();
        });
    },
    cancel: function() {
        calc.removeHandlers();
        $("#calcBoard").trigger("calcCancel", calc.calculator.display());
    },
    removeHandlers: function() {
        // 各htmlに仕込んだハンドラー削除
        $.each(calc.eventIds, function(i, id){
            clearTimeout(id);
        });
        calc.eventIds = [];
        $("body > *").unbind("click", calc.cancel);
    }
}
