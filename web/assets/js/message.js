// Like
$('.like').click(function(e){
    e.preventDefault();
    var $this = $(this);
    var id = $(this).data('id');
    $.get($(this).attr('href') + "?mid=" + id, function () {
        var sum;
        if ($this.data('action') == "like") {
            sum = 1;
        } else {
            sum = -1;
        }
        $('.likes-' + id).html(parseInt($('.likes-' + id).text()) + sum);
    })
    .fail(function() {
        alert('Erro!');
    });
});

$('.opinion').click(function(e){
    e.preventDefault();
    var id = $(this).data('id');
    $('.like-buttons-' + id).hide();
    $.get("opinate?mid=" + id, function () {
       $('.like-buttons-' + id).show();
    })
    .fail(function() {
        
    });
});


$('.load-comments').click(function(e){
    e.preventDefault();
    var id = $(this).data('id'),
        $this = this;
    $(this).parent().load($(this).attr('href') + '?mid=' + id); 
});


function replaceMentionsWithLinks(text) {
    return text.replace(/@([a-z\d_]+)/ig, '<a href="http://localhost:8084/projeto_bd/find?search=$1">@$1</a>'); 
}

function replaceHashtagWithLinks(text) {
    return text.replace(/#([a-z0-9][a-z0-9\-_]*)/ig, '<a href="http://localhost:8084/projeto_bd/hashtag?hash=$1">#$1</a>'); 
}

var comments = document.getElementsByClassName('comment-itself');
for (var i = 0; i < comments.length; i++) {
    comments[i].innerHTML = replaceMentionsWithLinks(comments[i].innerHTML);
    comments[i].innerHTML = replaceHashtagWithLinks(comments[i].innerHTML);
}
