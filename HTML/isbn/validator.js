'use strict';

jQuery(function($) {
    var validator = {form: '#validator', input: '#validator input:text'}
    var result = {valid: '#9effb1', invalid: '#f01818'}

    $(validator.input).keyup(function() {
        if ($(this).val().length > 0) {
            $(this).css('color', ($(this).isIsbn()) ? result.valid : result.invalid);
        }
    });

    $(validator.form).submit(function() {
        return false;
    });

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