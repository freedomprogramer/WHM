//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
// = require_tree .

function show_confirm(){
  if(confirm('你确定要删除吗？')){
    $('#overlay').css('display','block');
  }else{
    return false;
  }
}

$(document).ready(function(){
  $('.overlay').click(function(){
    $('#overlay').css('display','block');
  })
})