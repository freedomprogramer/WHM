//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
// = require_tree .

function delete_confirm( hash ){
  if(confirm('你确定要删除吗？')){
    $('#overlay').css('display','block');
    $('<form action=' + hash['url'] +' method="POST"/>')
      .append($('<input type="hidden" name="_method" value="delete"/>'))
      .submit();
  }
}

$(document).ready(function(){
  $('.overlay').click(function(){
    $('#overlay').css('display','block');
  })
})