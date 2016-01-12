var User = function(el) {
  var self = this;
  this.el = el;
  this.id = $("#user_id option:selected")[0].value;
  this.views = $("#views");

  this.loadViews();
  $(this.el).on('change', this.loadViews.bind(this));
  $("#update_permissions").on('click', function(event) {
    event.preventDefault();
    self.updatePermissions();
  });
}

User.prototype.updatePermissions = function() {
  var self = this;
  var view_ids = [];
  $('input[name="view_ids[]"]:checked').each(function() {
    view_ids.push($(this).val());
  });
  $.ajax({
    url: "/users/" + self.id + "/permissions",
    method: "POST",
    data: { view_ids: view_ids },
    dataType: "JSON"
  }).done(function(data) {
    $(".notice").text("Permissions Added Successfully");
  }).error(function(error) {
    $(".error").text("Permissions Not Added Successfully");
  })
}

User.prototype.loadViews = function() {
  var self = this;
  this.id = $("#user_id option:selected")[0].value;
  $.ajax({
    url: "/users/" + self.id + "/permissions",
    method: "GET",
    dataType: "JSON"
  }).done(function(data) {
    $('input[name="view_ids[]"]').each(function() {
      if($.inArray(parseInt($(this).val()),data.data) >= 0) {
        $(this).attr('checked', true);
      } else {
        $(this).attr('checked', false);
      }
    });
  });
}

function dash() {
  var nonAdmin = new User("#user_id");
}

$(document).on('page:load',function(){
  if($("#user_id").length > 0) { dash() };
});
$(document).on('ready',function(){
  if($("#user_id").length > 0) { dash() };
});
