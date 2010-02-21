puts "Installing "

["flash", "images", "javascripts", "stylesheets"].each do |dir|
  FileUtils.cp_r("#{File.dirname(__FILE__)}/public/#{dir}", "#{RAILS_ROOT}/public/")
end
FileUtils.cp_r("#{File.dirname(__FILE__)}/config/amazon_s3.yml", "#{RAILS_ROOT}/config/amazon_s3.yml")

puts "Complete"

puts "You will also need to have the jquery and jquery-ui libraries installed."
