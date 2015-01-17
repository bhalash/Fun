// Will never be true. 
var NOTICED_BY_SENPAI = false;
var header = $('.senpai');

function centerHeader() {
    $(header).css('margin-top', ($(window).height() * 0.5) - (header.height() * 0.5) + 'px');
}

$(window).load(function() {

    if (NOTICED_BY_SENPAI) {
        header.text('yes');
    } else {
        header.text('no');
    }

    centerHeader();
});

$(window).resize(function() {
    centerHeader();
});