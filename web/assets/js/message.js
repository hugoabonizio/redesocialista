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


function replaceAtMentionsWithLinks(text) {
    return text.replace(/@([a-z\d_]+)/ig, '<a href="http://localhost:8084/projeto_bd/find?search=$1">@$1</a>'); 
}
var comments = document.getElementsByClassName('comment-itself');
for (var i = 0; i < comments.length; i++) {
    comments[i].innerHTML = replaceAtMentionsWithLinks(comments[i].innerHTML);
}
