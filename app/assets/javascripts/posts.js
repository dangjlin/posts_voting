// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $(".form_vote").submit(function(event){
    event.preventDefault();
    var action = $(this).attr('action');
    var method = $(this).attr('method');
    $.ajax({
      method: method,
      url: action,
      dataType: 'script'
    });
  });
});

