var datePicker = function(el) {
  this.el = $(el);
  this.startDate = $('#start_date').datepicker({ dateFormat: "yy-mm-dd", defaultDate: -7 });
  this.endDate = $('#end_date').datepicker({ dateFormat: "yy-mm-dd", defaultDate: -1 });
  this.view_id = location.pathname.split('/')[location.pathname.split('/').length -2];
  this.myMentions = new mentionTable("#mention_list");
  var self = this;
  this.updateObjects();

  $(this.startDate).on('change', function(){ 
    self.updateObjects();
  });

  $(this.endDate).on('change', function(){
    self.updateObjects();
  });
}

datePicker.prototype.updateObjects = function() {
  var self = this;
  if (start_date.value > end_date.value) { 
    return alert("Start Date Must be before End Date");
  }

  $.ajax({
    url: "/views/" + self.view_id + "/mentions",
    method: "GET",
    data: { start_date: start_date.value, end_date: end_date.value },
    dataType: "JSON"
  }).done(function(data){
    self.myMentions.fill(data.mention_data);
  })
}

var mentionTable = function(el) {
  this.el = el;
}

mentionTable.prototype.fill = function(mention_data) {
  var self = this;
  $('#mention-count').text(mention_data.mention_count);
  $(this.el).html('<ol></ol>');
    var mentions = mention_data.mentions;
    var twitter_handle = mention_data.twitter_handle;
    $(mentions).each(function(index){
        var mention = mentions[index];
        var tweet = "<li class='h-entry tweet customisable-border'>" +
                     "<div class='header'>" + 
                       "<a class='u-url permalink customisable-highlight' href='https://twitter.com/" + mention.user_handle + "/status/" + mention.twitter_id + "' target='_blank'>" + mention.published_at.substr(0,10) + "</a>" +
                       "<div class='h-card p-author'>" + 
                         "<a class='u-url profile' href='https://twitter.com/" + mention.user_handle + "' target='_blank'>" + 
                           "<img class='u-photo avatar' alt='' src='"+ mention.user_image +"' >" +
                           "<span class='full-name'>" +
                             "<span class='p-name customisable-highlight'><b>" + mention.user_name + " </b></span>" +
                             "</span>" +
                           "<span class='p-nickname' dir='ltr'>@"+ mention.user_handle +"</span>" +
                         "</a>" +
                       "</div>" +
                     "</div>" +
                     "<div class='e-entry-content'>" +
                       "<p class='e-entry-title' lang='' dir=''>" + mention.body +
                     "</div>" +
                     "<div class='footer customisable-border'</div></li>"

        $(self.el).find('ol').append(tweet);
        /*
        $('.tweet').tipsy({
          gravity: 'sw',
          html: true,
          title: function() {
            html = "<div class='tooltip-title'>Total Mentions<br>" + mention.mention_count + "</div>";
            return html;
          }
        });
        */
     })
}

function init() {
  if($("#twitter-date-picker").length > 0) { new datePicker("#twitter-date-picker") }
}

$(document).on('page:load', function(){
  init();
});

$(document).on('ready', function(){
  init();
});
