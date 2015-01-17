setInterval(function() {
    $('.time').text($.now());
    $('.counter').css('margin-top', ($(window).height() * 0.5) - $('.counter').height() * 0.5 + 'px');
}, 1);

$(window).load(function() {
    var audio = $('.nyan-audio')[0];

    $('.nyan a').click(function() {
        if (audio.paused) {
            audio.volume = 0.2;
            audio.play();
            $('.nyan').css('opacity', 1);
        } else { 
            audio.pause();
            $('.nyan').css('opacity', 0.2);
        }
    });
});
