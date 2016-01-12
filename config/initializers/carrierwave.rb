CarrierWave.configure do |config|
  # config.fog_credentials = {
  #   provider:              'AWS',
  #   aws_access_key_id:     ENV['AWS_ACCESS_KEY'],
  #   aws_secret_access_key: ENV['AWS_SECRET_KEY'],
  #   #region:                'us-west-2'
  # }
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     "AKIAJV7LT4D64IDFOLSA",
    aws_secret_access_key: "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",
    host: 's3.amazonaws.com',
    region: 'us-west-2'
  }
  # config.fog_directory  = ENV['AWS_DIR']
  config.fog_directory  = 'aristotleanalyticsdev'
  config.fog_public     = false     # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } 
end

