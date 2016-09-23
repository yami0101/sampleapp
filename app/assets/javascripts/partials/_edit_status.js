$('body').on('click', '.edit-status', function() {
    $.getScript('/status', function(data, status, xhr) {
        if (xhr.status == 200) {
            eval(data);
        }
    });
});