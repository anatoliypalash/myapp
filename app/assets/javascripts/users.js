$(document).on('ready, page:load', function(){
  if ($('#sortable').length) User.Sort();

})

var User = {}

User.Sort = function() {
  var cells, desired_width, table_width;
  if ($('#sortable').length > 0) {
    table_width = $('#sortable').width();
    cells = $('.table').find('tr')[0].cells.length;
    desired_width = table_width / cells + 'px';
    //$('.table td').css('width', desired_width);
    return $('#sortable').sortable({
      axis: 'y',
      items: '.item',
      cursor: 'move',
      sort: function(e, ui) {
        return ui.item.addClass('active-item-shadow');
      },
      stop: function(e, ui) {
        ui.item.removeClass('active-item-shadow');
        return ui.item.children('td').effect('highlight', {}, 1000);
      },
      update: function(e, ui) {
        var item_id, position;
        item_id = ui.item.data('item-id');
        console.log(item_id);
        position = ui.item.index();
        return $.ajax({
          type: 'POST',
          url: '/users/update_row_order/',
          dataType: 'json',
          data: {
            user: {
              user_id: item_id,
              row_order_position: position
            }
          }
        });
      }
    });
  }
}
