puts "Installing "

["flash", "images", "javascripts", "stylesheets"].each do |dir|
  FileUtils.cp_r("#{File.dirname(__FILE__)}/public/#{dir}", "#{RAILS_ROOT}/public/")
end
FileUtils.cp_r("#{File.dirname(__FILE__)}/config/amazon_s3.yml", "#{RAILS_ROOT}/config/amazon_s3.yml") unless File.exists?("#{RAILS_ROOT}/config/amazon_s3.yml")

puts "Complete"
