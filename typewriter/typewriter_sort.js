'use strict';

var count = 0;
var typewriter = 'typewriter';
var typewriterSorted = 'eeiprrttwy';
var checkedPermutations = [];

String.prototype.scramble = function() {
    var scrambledStr = '';
    var arr = this.split('');

    for (var i = arr.length - 1; i > 0; i--) {
        var random = randomInt(0, arr.length -1);
        var temp = arr[i];
        arr[i] = arr[random];
        arr[random] = temp;
    }

    return arr.join('');
}

function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function scrollText(callback) {
    $('.the_fun_bit ul').each(function() {
        $(this).append('<li>' + typewriter.scramble() + '</li>');

        if ($(this).children().length > 10) {
            $(this).children().slice(0, 1).remove();
        }

        $('h2').text(count++);
    });

    callback();
}

var permute = setInterval(function() {
    scrollText(function() {       
        $('.the_fun_bit ul li:nth-child(5)').each(function() {
            if ($(this).text() == typewriterSorted) {
                $('.fanfare')[0].play();
                clearInterval(permute);
                $('h2').css('color', '#00ff33');
                $(this).css('color', '#00ff33');
            }
        });
    });
}, 1);