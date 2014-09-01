
// Apagar mensagem
$('.remove-message').click(function(e) {
    var id = $(this).data('id');
    var $this = $(this);
    $.get('message/destroy?id=' + id, function () {
        $this.parent().parent().hide('slow');
    })
    .fail(function() {
        //console.log('message/destroy?id=' + id);
        alert('Erro ao tentar excluir!');
    });
    
});

// Apagar grupo
$('.remove-group').click(function(e) {
    e.preventDefault();
    var $this = $(this);
    
    $.get($(this).attr('href'), function () {
        $this.parent().parent().hide('slow');
    })
    .fail(function() {
        alert('Erro ao tentar excluir!');
    }); 
});

// Adicionar membro
$('.add-member').click(function(e) {
    e.preventDefault();
    var $this = $(this);
    
    $.get($(this).attr('href'), function () {
        $this.parent().parent().hide('slow');
    })
    .fail(function() {
        alert('Membro já adicionado!');
    });
    
});

// Remover membro
$('.remove-member').click(function(e) {
    e.preventDefault();
    var $this = $(this);
    
    $.get($(this).attr('href'), function () {
        $this.parent().parent().hide('slow');
    })
    .fail(function() {
        alert('Membro já removido!');
    });
});


// Excluir perfil
$('.destroy-profile').click(function(e) {
    e.preventDefault();
    if (confirm("Tem certeza, mano?!")) {
        document.location = $(this).attr('href');
    }
});


// Seguir
$('.follow').click(function(e) {
    e.preventDefault();
    var $this = $(this);
    console.log($(this).attr('href') + "create?follow=" + $(this).data('id'));
    $.get($(this).attr('href') + "create?follow=" + $(this).data('id'), function () {
        $this.removeClass('btn-success')
            .removeClass('follow')
            .addClass('unfollow')
            .addClass('btn-warning')
            .html('<i class="glyphicon glyphicon-remove"></i> Deseguir');
    document.location = document.location;
    })
    .fail(function() {
        alert('Erro ao tentar excluir!');
    });
});

// Deseguir
$('.unfollow').click(function(e) {
    e.preventDefault();
    var $this = $(this);
    console.log($(this).attr('href') + "destroy?follow=" + $(this).data('id'));
    $.get($(this).attr('href') + "destroy?follow=" + $(this).data('id'), function () {
        $this.removeClass('btn-warning')
            .removeClass('unfollow')
            .addClass('follow')
            .addClass('btn-success')
            .html('<i class="glyphicon glyphicon-plus"></i> Seguir');
    document.location = document.location;
    })
    .fail(function() {
        alert('Erro ao tentar excluir!');
    });
    
});

document.getElementById('avanced-search-button').onclick = function (e) {
    e.preventDefault();
    document.forms[0].action = 'advanced_search';
    document.forms[0].submit();
};