namespace :assets do
  task :custom do
    Rake::Task['assets:precompile'].invoke
    File.open("./custom_#{Time.now.to_i}", 'w').close 
  end
end
