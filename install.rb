# Install hook code here
require 'fileutils'

# create directory to store hashes in
FileUtils.mkpath_p("#{RAILS_ROOT}/db/tokyo/#{RAILS_ENV}") 
