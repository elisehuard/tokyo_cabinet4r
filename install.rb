# Install hook code here
require 'fileutils'

# create directory to store data stores in
FileUtils.mkpath_p("#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}") 
