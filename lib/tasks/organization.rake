require 'rake'
require 'rubygems'
require 'httparty'
require 'uri'
namespace :organization do
desc 'Stored the site url in site details'
task :pull_all => :environment do
 (1..1000).each do |n|
 p "pageno_#{n}"
 p "Date:#{(Date.today).strftime('%Y-%m-%d')}"
 response = HTTParty.get("https://pipeline-api.locallabs.com/api/v1/organizations?min_updated_at=#{(Date.today).strftime('%Y-%m-%d')}&page=#{n}",headers: {"Authorization" => "TJX5h5NUpQRreu6z9DEh"})
	json = JSON.parse(response.body)
	   if !json.nil? && json !=[]
			i=0
			json.each do |item|
				begin
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
			  	rescue
			  	p "bad url_page_no#{n}"
			  	end  #begin end
			end #loop end
		else
	   	   break
	    end  # emtpy conditon end
    end  #outer loop end
end   #task end
end   #namespace end

