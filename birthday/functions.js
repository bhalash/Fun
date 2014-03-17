var today = new Date($.now());
var dummy = new Date('07 May 2014 23:59:00 +0000').getTime()
var year = (new Date).getFullYear();

var birthday = {        
    begin : new Date('08 May ' + year + ' 00:00:00 +0000').getTime(),
    end   : new Date('08 May ' + year + ' 23:59:59 +0000').getTime()
};

var countdown = {
    // Derive human-readable countdown from birthday.begin.
    days           : Math.floor(((birthday.begin - $.now()) / 86400) / 1000),
    hours          : 24 - today.getHours()   - 1,
    minutes        : 60 - today.getMinutes() - 1,
    seconds        : 60 - today.getSeconds() - 1,
    centiseconds   : Math.floor(100 - (1000 - today.getMilliseconds()) / 10),
    milliseconds   : Math.floor(100 - (1000 - today.getMilliseconds()))
};

function updateCountdown() {
    countdown.days          = Math.floor(((birthday.begin - $.now()) / 86400) / 1000);
    countdown.hours         = 24 - today.getHours()   - 1;
    countdown.minutes       = 60 - today.getMinutes() - 1;
    countdown.seconds       = 60 - today.getSeconds() - 1;
    countdown.centiseconds  = Math.floor(100 - (1000 - today.getMilliseconds()) / 10);
    countdown.milliseconds  = Math.floor(100 - (1000 - today.getMilliseconds()));
}

function drawCountdown() {
    $('#centiseconds').text(countdown.centiseconds);
    $('#seconds').text(countdown.seconds);
    $('#minutes').text(countdown.minutes);
    $('#hours').text(countdown.hours);
    $('#days').text(countdown.days);
}

function bcHeight() {
    // Main container height, to fit the page.
    $('.birthday-content').css('min-height', $(window).height() + 'px');
}

function countdownPos() {
    // Position of countdown counter.
    var a = $('.birthday-content');
    var b = $('.birthday-countdown').height();
    var c = 43;
    var d = ($(window).height() * 0.5) - ((b + c) * 0.5);

    // a.css('margin-top', d + 'px');
}

function timerHeight() {
    // Time width is dynamic, so timer height = width.
    var a = $('.counter');
    a.css('height', a.width() + 'px');
}

function debugMsgs() {
    console.log(
        'Current time:\t\t'     + $.now() + '\n' +
        'Birthday start:\t\t'   + birthday.begin + '\n' +
        'Birthday end:\t\t'     + birthday.end + '\n' +
        '------' + '\n' +
        'Days to:\t\t\t'        + countdown.days + '\n' +
        'Hours to:\t\t\t'       + countdown.hours + '\n' +
        'Minutes to:\t\t\t'     + countdown.minutes + '\n' +
        'Seconds to:\t\t\t'     + countdown.seconds + '\n' +
        'Centiseconds to:\t'    + countdown.cs
    );
} 

setInterval(function() {
    updateCountdown();
    drawCountdown();
}, 10);

$(document).ready(function() {
    bcHeight();
    timerHeight();
    countdownPos();
    debugMsgs();
});

$(window).on('resize',function() {
    bcHeight();
    timerHeight();
    countdownPos();
});
