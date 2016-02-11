var dashDatePicker = function(el) {
  this.el = $(el);
  this.startDate = $('#start_date').datepicker({ dateFormat: "yy-mm-dd", defaultDate: -7 });
  this.endDate = $('#end_date').datepicker({ dateFormat: "yy-mm-dd", defaultDate: -1 });
  this.table = new metricsTable("#agg_metrics");
  this.dc = new domainCloud("#domain_cloud");
  this.pageViewBars = new barGraph("#bottom_third");
  this.view_id = location.pathname.split('/')[location.pathname.split('/').length -1];
  this.myPieGraph = new pieGraph("#visitor_profile");
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

dashDatePicker.prototype.updateObjects = function() {
  if (start_date.value > end_date.value) { 
    return alert("Start Date Must be before End Date");
  }

  var self = this;
  $.ajax({
    url: "/views/" + self.view_id + "/daily_view_metrics",
    method: "GET",
    data: { start_date: start_date.value, end_date: end_date.value },
    dataType: "JSON"
  }).done(function(data){
    self.table.setMetrics(data.daily_view_metrics);
  });

  $.ajax({
    url: "/views/" + self.view_id + "/dashboard",
    method: "GET",
    data: { start_date: start_date.value, end_date: end_date.value },
    dataType: "JSON"
  }).done(function(data){
    self.dc.fill(data.domain_sessions);
    self.pageViewBars.display(data.url, data.page_views);
    self.myPieGraph.setData(data.visitor_profile);
    self.myMentions.fill(data.mention_data);
  })
}

var mentionTable = function(el) {
  this.el = el;
}

mentionTable.prototype.fill = function(mention_data) {
  var self = this;
  $(this.el).html('<ol></ol>');
    var mentions = mention_data.mentions;
    var twitter_handle = mention_data.twitter_handle;
    $(mentions).each(function(index){
        var mention = mentions[index];
        var tweet = "<li class='h-entry tweet customisable-border'>" +
                     "<div class='header'>" + 
                       "<a class='u-url permalink customisable-highlight' href='https://twitter.com/" + mention.user_handle + "/status/" + mention.twitter_id + "'>" + mention.published_at.substr(0,10) + "</a>" +
                       "<div class='h-card p-author'>" + 
                         "<a class='u-url profile' href='https://twitter.com/" + mention.user_handle + "'>" + 
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
     })
}

var pieGraph = function(el) {
  this.el = el;
  this.dropdown = $("#collection");
  var self = this;

  $(this.dropdown).on("change", function(event) {
    self.display();
  });
} 

pieGraph.prototype.setData = function(data) {
  this.data = data;
  this.display();
}

pieGraph.prototype.display = function() {
  $(this.el).find("svg").remove();
  var collection = $(this.dropdown)[0].value;

  if (collection == "City") {
    this.collection = this.data.city;
  } else if (collection == "Acquisition") {
    this.collection = this.data.acquisitions;
  } else if (collection == "Referral") {
    this.collection = this.data.referral;
  } else if (collection == "User Type") {
    this.collection = this.data.user_type;
  }

  var self = this;

  var w = 300,                        //width
  h = w,                            //height
  r = w / 2,                            //radius
  inner = (3 * r) / 4;
  var color;

  if (collection == "User Type") {
    color = d3.scale.ordinal()
      .range(["rgb(254, 217, 118)","rgb(227, 26, 28)"]);
  } else {
    color = d3.scale.ordinal()
      .range(["#ffffcc","#ffeda0","#fed976","#feb24c","#fd8d3c","#fc4e2a","#e31a1c","#bd0026","#800026"]);
  }

  var vis = d3.select(this.el)
    .append("svg:svg")              //create the SVG element inside the <body>
   .data([self.collection])                   //associate our data with the document
      .attr("width", w)           //set the width and height of our visualization (these will be attributes of the <svg> tag
      .attr("height", h)
    .append("svg:g")                //make a group to hold our pie chart
      .attr("transform", "translate(" + r + "," + r + ")")    //move the center of the pie chart from 0, 0 to radius, radius

  var arc = d3.svg.arc()              //this will create <path> elements for us using arc data
    .innerRadius(inner)
    .outerRadius(r);

  var pie = d3.layout.pie()           //this will create arc data for us given a list of values
    .value(function(d) { return d.value; });    //we must tell it out to access the value of each element in our data array

  var arcs = vis.selectAll("g.slice")   //this selects all <g> elements with class slice (there aren't any yet)
    .data(pie)                          //associate the generated pie data (an array of arcs, each having startAngle, endAngle and value properties) 
    .enter()                            //this will create <g> elements for every "extra" data element that should be associated with a selection. The result is creating a <g> for every object in the data array
      .append("svg:g")              //create a group to hold each slice (we will have a <path> and a <text> element associated with each slice)
        .attr("class", "slice");    //allow us to style things in the slices (like text)

  arcs.append("svg:path")
    .attr("fill", function(d, i) { return color(i); } ) //set the color for each slice to be chosen from the color function defined above
    .attr("d", arc);                                    //this creates the actual SVG path using the associated data (pie) with the arc drawing function

  $('.slice').tipsy({
    gravity: 'sw',
    html: true,
    title: function() { 
      html = "<div class='tooltip-title'>" + this.__data__.data.key + "<br>" + addCommas(this.__data__.value);
      if (this.__data__.data.pct) {
        html += " (" + this.__data__.data.pct + "%)";
      }
      html += "</div>";
      return html;
    }
  });
}

var barGraph = function(el) {
  this.el = el;
}

barGraph.prototype.display = function(url, permas) {
  $(this.el).find("svg").remove();
  var url = url;
  var permas = permas;
  var chartHeight = 400;
  var chartWidth = 960;

  var svg = d3.select(this.el).append('svg')
   .attr('height', chartHeight)
   .attr('width', chartWidth);
  var g = svg.append('g');
  var marker = '';
  var entries = permas.length;
  var values = permas.map(function(d) { return d.page_views });

  var y = d3.scale.linear()
    .range([150,0])
    .domain([d3.min(permas), d3.max(permas)])

  var barWidth = chartWidth / entries;
  var rect = g.selectAll('.bar').data(permas)
    .enter().append('rect');

  rect.attr('class', 'bar')
    .attr('width', barWidth)
    .attr('height', function(d) { 
      return Math.abs((Number(d.page_views) / d3.max(values)) * (chartHeight/2)) 
    })
    .attr('x', function(d,i) { return i * barWidth })
    .attr('y', function(d) {  return (chartHeight/2) - ((Number(d.page_views) / d3.max(values)) * (chartHeight/2)) } )

  $('.bar').on('click', function(){
    window.open(url + this.__data__.permalink);
  })

  $('.bar').tipsy({
    gravity: 'sw',
    html: true,
    title: function() { 
      html = "<div class='tooltip-title'>" + 
        "<span class='page_views'>Views: " + addCommas(this.__data__.page_views) + "</span><br>" + 
        "<span class='perma'>Permalink: " + toSentence(this.__data__.permalink) + "</span></div>";
      return html;
    }
  });
}

var metricsTable = function(el) {
  this.el = $(el);
  this.storiesProduced = $('#stories_produced_val');
  this.storiesRead = $('#stories_read_val');
  this.uniqueReaders = $('#unique_readers_val');
  this.pgsPerSession = $('#pgs_per_session_val');
  this.avgSessionDuration = $('#avg_session_duration_val');
  this.view_id = location.pathname.split('/')[location.pathname.split('/').length -1];
  this.datePicker = datePicker;
}

metricsTable.prototype.setMetrics = function(dailyViewMetrics) {
  this.storiesProduced.text(addCommas(dailyViewMetrics.pages_viewed));
  this.storiesRead.text(addCommas(dailyViewMetrics.page_view_count));
  this.uniqueReaders.text(addCommas(dailyViewMetrics.user_count));
  this.pgsPerSession.text(dailyViewMetrics.pages_per_session);
  this.avgSessionDuration.text(dailyViewMetrics.avg_session_duration);
}

var domainCloud = function(el) {
  this.el = el;
}

// domainCloud.prototype.fill = function(data) {
//   $(this.el).html('');
//   $(this.el).jQCloud(data, { shape: "cloud" });
// }

var tag_list = new Array();
domainCloud.prototype.fill = function(data) {
  var start_date=$("#start_date").val();
  var end_date=$("#end_date").val();
  for ( var i = 0; i < data.length; ++i ) {
    var url = data[i].key;
    var url_val = data[i].value;
    console.log(url+"......");
    var new_url = url.split("^");
    var url_name=new_url[0]
    var url_link=new_url[1]
    var view_id=$("#view_id").val();
    if( url.includes("other"))
      {
          console.log(1);
         tag_list.push({text: url, weight: url_val});
      }
      else if (url.includes("unknown."))
      {

      }
      else
      {
        console.log(view_id);
        console.log(url_name+"---"+url_link);
        tag_list.push({
        text: url_name, weight: url_val, link: {href: "/url_dashboard?url="+url_link+"&start_date="+start_date+"&end_date="+end_date+"&view_id="+view_id+"&c_name="+url_name, target: "_blank"}
        // text: url_name, weight: url_val, link: "/url_dashboard?url="+url_link+"&start_date="+start_date+"&end_date="+end_date+"&view_id="+view_id
         });
      }
}
  // var tag_list = data
  $(this.el).html('');
  $(this.el).jQCloud(tag_list, { shape: "cloud" });
}

function begin() {
  if($("#date_picker").length > 0) { new dashDatePicker("#date_picker") }
}

$(document).on('page:load', function(){
  begin();
});

$(document).on('ready', function(){
  begin();
});

function toSentence(permalink) {
  arr = permalink.split("/");
  sentence = arr[arr.length - 1];
  return sentence.replace(/-/g, " ");
}

function addCommas(num) {
  if (num) {
    var wholeNum = Math.abs(num);
    var dec;
    var commad = '';
    var neg = num < 0;
    var decSpot = num.toString().indexOf(".");

    if (decSpot >= 0) {
      wholeNum = Number(wholeNum.toString().substr(0,decSpot));
      dec = (Math.abs(num) % 1).toFixed(2);
    }
    dString = wholeNum.toString();
    for(var i = 0; i < dString.length; i++) {
      if (i % 3 == 0 && i > 0) {
        commad = "," + commad;
      }
      commad = dString[dString.length - i - 1] + commad;
    }

    if (dec) {
      commad = commad + "." + dec[2] + dec[3];
    }

    if (neg) {
      commad = "-" + commad;
    }
    return commad;
  } else {
    return "0"
  }
}
