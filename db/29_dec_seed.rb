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
# (1..20).each do |i|
# 	begin
# 	p "page_no#{i}"
#  response = HTTParty.get("https://pipeline-api.locallabs.com/api/v1/stories?page=#{i}&per_page=100",headers: {"Authorization" => "TJX5h5NUpQRreu6z9DEh"})
# 		json = JSON.parse(response.body)
# p "1111"
# json.each do |item|
# 	  	org_ids = item['organization_ids']
# 	  	org_id = item['organization_ids'].count
# 			if !org_ids.nil? && org_id > 0
# 			old_story=Story.where("story_id=?",item['id'].to_s).last
# 				if org_id == 1
# 					story=Story.new
# 					story.story_id = item['id']
# 					story.community_id= item['community_id']
# 					story.published_at= item['published_at']
# 					story.type_id= item['type_id']
# 					story.headline= item['headline']
# 					story.author= item['author']
# 					story.published= item['published']
# 					story.paid= item['paid']
# 					story.organization_id= item['organization_ids'][0]
# 					story.p_no = i
# 					story.save if old_story.nil?
# 				elsif org_id > 1
# 					l = 0
# 					org_ids.each do |j|
# 						# p item['organization_ids'][l]
# 						story=Story.new
# 						story.story_id = item['id']
# 						story.community_id= item['community_id']
# 						story.published_at= item['published_at']
# 						story.type_id= item['type_id']
# 						story.headline= item['headline']
# 						story.author= item['author']
# 						story.published= item['published']
# 						story.paid= item['paid']
# 						story.organization_id= item['organization_ids'][l]
# 						story.p_no = i
# 						story.save if old_story.nil?
# 						l = l+1
# 					end
# 				end
# 			end
#  		end
# 	rescue
# 	p "bad url_page_no#{i}"
# 	end
# end

# ip address download form pipeline API

b_url=[]
error_page=[]
 (1..4).each do |s|
 	p "#{(Date.today-s).strftime('%Y-%m-%d')}"
 # begin
	# p (Date.today-s)
 # n=1
 (1..500).each do |n|
 p "pageno_#{n}"
 response = HTTParty.get("https://pipeline-api.locallabs.com/api/v1/organizations?min_updated_at=#{(Date.today-s).strftime('%Y-%m-%d')}&page=#{n}",headers: {"Authorization" => "TJX5h5NUpQRreu6z9DEh"})
	json = JSON.parse(response.body)
	begin
	   if !json.nil? && json !=[]
	   	# p "not empty"
		i=0
		json.each do |item|
			begin
		    if !item['org_site'].nil? && item['org_site'] != ""  
		    url= item['org_site'].lstrip
			url=url.gsub('///','//')
		    uri = URI.parse(url)
		    f_url = uri.scheme+"://"+uri.host 
		    end
			if !item['ips'].nil? && item['ips'] != "" &&  item['ips'] != []
			old_ip=NewPipelineApi.where("api_id=?",f_url).last if !item['org_site'].nil? && item['org_site'] != "" 
					if !old_ip.nil? && old_ip.present?
						old_ip.api_id = item['id']
						old_ip.name= item['name'].lstrip if !item['name'].nil? && item['name'] != ""  
						old_ip.url= f_url if !item['org_site'].nil? && item['org_site'] != ""  
						old_ip.ip= item['ips'][0]["provider"]
						old_ip.save 
					else
						npi=NewPipelineApi.new
						npi.api_id = item['id']
						npi.name= item['name'].lstrip if !item['name'].nil? && item['name'] != ""  
						npi.url= f_url if !item['org_site'].nil? && item['org_site'] != ""  
						npi.ip= item['ips'][0]["provider"]
						npi.save 
					end
			end
	 	    old_url=NewPipeline.where("api_id=?",url).last if !item['org_site'].nil? && item['org_site'] != "" 
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
		 rescue
		 p	b_url << item['id']	
		 p "bad url_page_no#{s}"
		 end  #inner begin end
		end #do loop end
		else
	   	p "empty"
	   	break
	   end  # array checking end
	   rescue
		 p "bad url_outer_page_no#{s}"
		 error_page << "#{(Date.today-s).strftime('%Y-%m-%d')}&page=#{n}"
	   end  #outer begin end
		 p "#{(Date.today-s).strftime('%Y-%m-%d')}"
		# rescue
		# p	b_url << s	
		# p "bad url_page_no#{s}"
		 end
	 end


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
