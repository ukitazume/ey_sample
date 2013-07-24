namespace :assets do
  task :custom do
    puts 'custom assets'
    File.open("./custom_#{Time.now.to_i}", 'w').close 
  end
end
