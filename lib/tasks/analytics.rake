namespace :analytics do
  desc 'pull Google Analytics for all Views by dates'
  task :pull_all => :environment do |t, args|
    begin
      View.pull_all
      View.get_mentions
    rescue
    end
  end
end



