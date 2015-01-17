'use strict';

jQuery(function($) {
    var validator = {form: '#validator', input: '#validator input:text'}
    var result = {valid: '#9effb1', invalid: '#f01818'}

    verticalCenter(validator.form);

    $(validator.input).keyup(function() {
        if ($(this).val().length > 0) {
            $(this).css('color', ($(this).isIsbn()) ? result.valid : result.invalid);
        }
    });

    $(validator.form).submit(function() {
        return false;
    });

    $(window).resize(function() {
        verticalCenter(validator.form);
    });

    function verticalCenter(div) {
        $(div).css('margin-top', $(window).height() * 0.5 - $(div).outerHeight() * 0.5).show();
    }

    $.fn.extend({
       isIsbn: function() {
            var isbn = this.val().replace(/[^0-9X.]/g, '');
            var num = 0;
            var cur = 0;

            if (isbn.length == 10) {
                for (var i = 0; i < isbn.length; i++) {
                    cur = isbn.charAt(i);
                    cur = (cur === 'X') ? 10 : cur;
                    num += cur * (10 - i);
                }
            } 

            return (num % 11 === 0 && num > 0) ? true : false;
       }
    });
});