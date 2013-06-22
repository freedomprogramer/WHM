//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

function show_mask_layer(){
  $('#mask-div').modal('show');
  $('#mask-div').on('shown', function(){
    $('.modal-backdrop').unbind('click');
  })
}

function delete_confirm( hash ){
  if(confirm('你确定要删除吗？')){
    show_mask_layer();
    $('<form action=' + hash['url'] +' method="POST"/>')
      .append($('<input type="hidden" name="_method" value="delete"/>'))
      .submit();
  }
}

$(document).ready(function(){
  $('.mask').click(function(){
    show_mask_layer();
  })
})