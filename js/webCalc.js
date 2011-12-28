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
    $(".calcButton", calc.$html).bind("click", function(evnet){
        // 各ボタンが押下された場合のイベント
    });
    $("body").append(calc.$html);
});

calc = {
    eventIds: [],
    start: function(ondecide, oncancel) {
        ondecide = ondecide || function(event, value){};
        oncancel = oncancel || function(event, value){};
        // TODO 決定時のイベントにバインド
        // TODO 2回連続で start された場合のハンドリング
        $("#calcBoard").show();
        calc.eventIds.push(
            setTimeout(function(){$("body > *:not(#calcBoard)").bind("click", calc.cancel);}, 0)
        );
    },
    cancel: function() {
        // 各htmlに仕込んだハンドラー削除
        $.each(calc.eventIds, function(i, id){
            clearTimeout(id);
        });
        calc.eventIds = [];
        $("body > *").unbind("click", calc.cancel);

        $("#calcBoard").trigger("calcCancel", calc.value).hide();
    }
    
}
