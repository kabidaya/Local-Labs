require 'rake'
require 'rubygems'
require 'httparty'
require 'uri'
namespace :organization do
	desc 'Stored the site url in site details'
	task :pull_all => :environment do
		  begin
		      NewPipelineApi.pull_all
	      rescue
	      end
	end   
end   

