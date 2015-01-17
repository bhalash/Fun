'use strict';

// The custom HTML element name.
var rainy = 'x-rainbow';

// A-l-l-l-l-l the colours of the rainbow.
var rainbowColours = [
    '#FF0000',
    '#FF7F00',
    '#FFFF00',
    '#00FF00',
    '#0000FF',
    '#4B0082',
    '#8B00FF',
];

function centerText(element) {
    // Vertically center the element's text.
    $(element).css('padding-top', $(window).height() * 0.5 - $(this).height() * 0.5);
}

$(function() {
    centerText('h1');

    var rainbowElement = document.registerElement(rainy, {
        // Declare the custom element.
        prototype: Object.create(HTMLElement.prototype)
    });

    $(rainy).each(function() {
        // Grab the text of each x-rainbow element and wrap it in a span with the given colour.
        var str = $(this).text();
        var newStr = '';

        for (var i = 0; i < str.length; i++) {
            newStr += '<span style="color: ' + rainbowColours[(i >= rainbowColours.length) ? i % rainbowColours.length : i]  + ';">' + str[i] + '</span>';
        }

        $(this).html(newStr);
    });
});

$(window).resize(function() {
    centerText('h1');
});