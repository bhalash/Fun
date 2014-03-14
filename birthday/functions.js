
var today = new Date($.now());

var birthday = new function() {        
    this.begin  = new Date('08 May 2014 00:00:01 +0000').getTime();
    this.end    = new Date('09 May 2014 00:00:01 +0000').getTime();
    this.dummy  = new Date('08 May 2014 11:59:20 +0000').getTime();
};

var timeTo = new function() {
    // Time to my birthday in milliseconds.
    this.ms       =   birthday.begin - $.now();
    this.seconds  =   this.ms / 1000;
    this.minutes  =   this.seconds / 60;  
    this.hours    =   this.minutes / 60;    
    this.days     =   this.hours / 24;
}

var countdown = {
    // Countdown to Christmas in May.
    days       : Math.floor((timeTo.ms / 86400) / 1000),
    hours      : 24 - today.getHours() - 1,
    minutes    : 60 - today.getMinutes() - 1,
    seconds    : 60 - today.getSeconds(),
    ms         : Math.floor(100 - (1000 - today.getMilliseconds()) / 100)
};

var isBirthday = isTimeBetweenDates($.now(), birthday.begin, birthday.end);

function isTimeBetweenDates(a,b,c) {
    // Check if a date falls between b and c.
    if (a >= b && a <= c) {
        return true;
    } else {
        return false;
    }
}

function bdMessage(a) {
    if (a == true) {
        $('.birthday-bool').text('Yes');
    } else {
        $('.birthday-bool').text('No');
    }
}

function bcHeight() {
    // Main container height, to fit the page.
    $('.birthday-content').css('min-height', $(window).height() + 'px');
}

function bdMessageHeight() {
    $('.birthday-bool').css('font-size', $(window).height() * 1.3 + 'px');
    $('.birthday-bool').css('line-height', $(window).height() + 'px');
}

function countdownPos() {
    // Position of countdown counter.
    var bc = $('.birthday-countdown');
    bc.css('left', ($(window).innerWidth() - bc.width()) * 0.5);
    bc.css('top', ($(window).innerHeight() - bc.height()) * 0.5);
}

function timerHeight() {
    // Width is dynamic.
    $('.timer').css('height', $('.timer').width() + 'px');
}

function insertCountdown() {
    if (countdown.seconds < 10) {
        $('#seconds').text('0' + countdown.seconds);
    } else {
        $('#seconds').text(countdown.seconds);
    }

    if (countdown.minutes < 10) {
        $('#minutes').text('0' + countdown.minutes);
    } else {
        $('#minutes').text(countdown.minutes);
    }

    if (countdown.hours < 10) {
        $('#hours').text('0' + countdown.hours);
    } else {
        $('#hours').text(countdown.hours);
    }

    if (countdown.hours < 10) {
        $('#days').text('0' + countdown.days);
    } else {
        $('#days').text(countdown.days);
    }
}

function debugMsgs() {
    console.log(
        'Current time:\t'   + $.now() + '\n' +
        'Birthday start:\t' + birthday.begin + '\n' +
        'Birthday end:\t'   + birthday.end + '\n' +
        'Difference:\t\t'   + timeTo.ms + '\n' +
        'Is birthday:\t'    + isBirthday + '\n' +
        '------' + '\n' +
        'Days to:\t\t'      + timeTo.days + '\n' +
        'Hours to:\t\t'     + timeTo.hours + '\n' +
        'Minutes to:\t\t'   + timeTo.minutes + '\n' +
        'Seconds to:\t\t'   + timeTo.seconds + '\n' +
        '------' + '\n' +
        'Days count:\t\t'   + countdown.days + '\n' +
        'Hours count:\t'    + countdown.hours + '\n' +
        'Minutes count:\t'  + countdown.minutes + '\n' +
        'Seconds count:\t'  + countdown.seconds + '\n' +
        'MS count:\t'       + countdown.ms
    );
} 

$(document).ready(
    function() {
        bcHeight();
        bdMessageHeight();
        timerHeight();
        countdownPos();
        bdMessage(isBirthday);
        insertCountdown();
        // debugMsgs();
    }
);

$(window).on('resize',
    function() {
        bcHeight();
        timerHeight();
        countdownPos();
    }
);

setInterval(
    // Update all values once per second.
    function() {
        if (countdown.days >= 0) {
            countdown.seconds--;

            if (countdown.seconds < 0) { 
                countdown.seconds = 59 
                countdown.minutes--;
            }

            if (countdown.minutes < 0) {
                countdown.minutes = 59;
                countdown.hours--;
            }

            if (countdown.hours < 0) {
                countdown.hours = 23;
                countdown.days--;
            }
        }

        insertCountdown();
    },
1000);
