require 'rake'
require 'rubygems'
require 'httparty'
require 'uri'
namespace :story do
desc 'Stored the site url in site details'
	task :pull_all => :environment do
 (16196..25000).each do |n|
 p "pageno_#{n}"
 begin
 response = HTTParty.get("https://pipeline-api.locallabs.com/api/v1/stories?published_at=#{(Date.today-1).strftime('%Y-%m-%d')}&page=#{n}",headers: {"Authorization" => "TJX5h5NUpQRreu6z9DEh"})
 #response = HTTParty.get("https://pipeline-api.locallabs.com/api/v1/stories?page=#{i}&per_page=100",headers: {"Authorization" => "TJX5h5NUpQRreu6z9DEh"})
	json = JSON.parse(response.body)
	if !json.nil? && json !=[]
	 	json.each do |item|
	 		# begin
		  	org_ids = item['organization_ids']
		  	org_id = item['organization_ids'].count
				if !org_ids.nil? && org_id > 0
				   old_story=Story.where("story_id=?",item['id'].to_s).last
					if org_id == 1
						if !old_story.nil?
						old_story.published_at= item['published_at']
						old_story.type_id= item['type_id']
						old_story.headline= item['headline']
						old_story.author= item['author']
						old_story.organization_id= item['organization_ids'][0]
						old_story.save 
						else
						story=Story.new
						story.story_id = item['id']
						story.community_id= item['community_id']
						story.published_at= item['published_at']
						story.type_id= item['type_id']
						story.headline= item['headline']
						story.author= item['author']
						story.published= item['published']
						story.paid= item['paid']
						story.organization_id= item['organization_ids'][0]
						story.save 
						end
					elsif org_id > 1
						l = 0
						org_ids.each do |j|
							if !old_story.nil?
							old_story.published_at= item['published_at']
							old_story.type_id= item['type_id']
							old_story.headline= item['headline']
							old_story.author= item['author']
							old_story.organization_id= item['organization_ids'][l]
							old_story.save 
							else
							story=Story.new
							story.story_id = j
							story.community_id= item['community_id']
							story.published_at= item['published_at']
							story.type_id= item['type_id']
							story.headline= item['headline']
							story.author= item['author']
							story.published= item['published']
							story.paid= item['paid']
							story.organization_id= item['organization_ids'][l]
							story.save 
							l = l+1
							end
						end
					end #org count end
				end #org nil end
	 		
	 	end # json loop end
	else
	   	   break
	end  # emtpy conditon end
	rescue
		p "bad url"
	end # begin end
 end #total page end
end # task end
end # namespace end
