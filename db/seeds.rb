# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# (1..25225).each do |j|


require 'rubygems'
require 'httparty'
require 'uri'


# ip address download form pipeline API

sheet=["644944581","644644236","644486785","645051487","644657254","644497686","645045985","645054547","645066674","645051048","645066727","645057085","644595486","644944599","645066675","645066728","645054550","644644947","645047981","645065736","644949181","644567675","645066673","645066671","645066718","644944561","645054880","645066744","645066745","644944555","645066742","645066688","645066106","645062147","644949185","644162674","644533446","644645585","645066685","645066686","645066687","645066684","645066683","645066739","644944615","645058585","644643184","645066736","644944606","645046387","645066737","644533803","645064330","645066733","644643193","645066734","645066731","644161815","645066730","645065861","645057135","644416123"]
p sheet.count
 # begin
	# p (Date.today-s)
 # n=1
 newarray=[]
 i=0
 sheet.each do |n|
 # p sheet.count
 response = HTTParty.get("https://pipeline-api.locallabs.com/api/v1/organizations/#{n}",headers: {"Authorization" => "TJX5h5NUpQRreu6z9DEh"})
	item = JSON.parse(response.body)
	   	# p "not empty"
		 if !item['org_site'].nil? && item['org_site'] != ""  
				    url= item['org_site'].lstrip
					url=url.gsub('///','//')
					url=url.split('?')
					url=url[0]
				    uri = URI.parse(url)
				    f_url = uri.scheme+"://"+uri.host 
				    end
					if !item['ips'].nil? && item['ips'] != "" &&  item['ips'] != []
					old_ip=NewPipelineApi.where("api_id=?",item['id'].to_s).last if !item['id'].nil? && item['id'] != "" 
							if !old_ip.nil? && old_ip.present?
								p "ipaddress"
								old_ip.api_id = item['id']
								old_ip.name= item['name'].lstrip if !item['name'].nil? && item['name'] != ""  
								old_ip.url= f_url if !item['org_site'].nil? && item['org_site'] != ""  
								old_ip.ip= item['ips'][0]["provider"]
								old_ip.save 
							else
								p "new ip address"
								npi=NewPipelineApi.new
								npi.api_id = item['id']
								npi.name= item['name'].lstrip if !item['name'].nil? && item['name'] != ""  
								npi.url= f_url if !item['org_site'].nil? && item['org_site'] != ""  
								npi.ip= item['ips'][0]["provider"]
								npi.save 
							end
					end
				 	    old_url=NewPipeline.where("api_id=?",item['id'].to_s).last if !item['id'].nil? && item['id'] != "" 
					 	if !old_url.nil? && old_url.present?
					 		old_url.api_id = item['id']	
							old_url.name=item['name'].lstrip if !item['name'].nil? && item['name'] != ""
							old_url.url= item['org_site'].lstrip if !item['org_site'].nil? && item['org_site'] != ""
							old_url.ip= item['ips'][0]["provider"] if !item['ips'].nil? && item['ips'] != "" &&  item['ips'] != []
					 		old_url.p_no= j
						    old_url.save 
					 	else
							site=NewPipeline.new
							site.api_id = item['id']	
							site.name=item['name'].lstrip if !item['name'].nil? && item['name'] != ""
							site.url= item['org_site'].lstrip if !item['org_site'].nil? && item['org_site'] != ""
							site.ip= item['ips'][0]["provider"] if !item['ips'].nil? && item['ips'] != "" &&  item['ips'] != []
					 		site.p_no= j
						    site.save 
						end
			
		p i=i+1
		  
		# end #do loop end
	   end  # array checking end
	   


# /stories/510579665-condo-association-accused-of-plotting-to-terrorize-resident-by-forcing-her-to-ride-in-elevators-with-dogs


     # dvpv_count = DailyViewPageView.where("permalink LIKE ?","%/stories/%").count
	# dvpv = DailyViewPageView.where("permalink LIKE ?","%/stories/%")
	#dvpv.count=511326

# dvpv = DailyViewPageView.where("permalink LIKE ? and date >= ?","%/stories/%","#{Date.today-5}")
# # 	dvpv = DailyViewPageView.where("permalink LIKE ?","%/stories/%").order('id DESC').limit(10000)
# 	p dvpv.count
# 	i=0
# 	dvpv.each do |d|
# 	old_id=Dailyviewstory.where("daily_view_id=?",d.id.to_s).last
# 	p old_id.daily_view_id if !old_id.nil?
# 	p i=i+1
# 	s_id=d.permalink.split('-')
# 	id = s_id[0].split('/')
# 	story_id = id[2]
#     dv=Dailyviewstory.new
# 	dv.view_id = d.view_id
# 	dv.story_id= story_id
# 	dv.date= d.date
# 	dv.daily_view_id=d.id
# 	dv.page_views = d.page_views
# 	dv.save if !story_id.nil? && story_id !="category" && old_id.nil?
# end






# p @ip= NewPipeline.where("ip IS NOT NULL").count
