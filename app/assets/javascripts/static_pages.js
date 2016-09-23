// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.javascripts.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(function() {
    var $textarea = $('#micropost_content');
    var $charcounter = $('.char-count');
    var maxLength = 140;

    $textarea.on('input', calculateChars);

    $textarea.trigger('input')

    function calculateChars() {
        $charcounter.text(this.value.length+'/'+maxLength)
    }
});
