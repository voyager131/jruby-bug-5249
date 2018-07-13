require 'open3'


#simulate I/O operation in original code. Set up a variable with the data
file_name = 'test.kob' #test file to convert
f = open(file_name)
f.rewind
raw_data = f.read(File.size(file_name))
f.close

#at this point variable f contains the raw file data to convert
Open3.popen3("decode") do |stdin, stdout, stderr, wait_thr|
  stdin.write(raw_data)
  stdin.close_write
  $image_data = stdout.read
  $status_message = stderr.read
  exit_status = wait_thr.value
end#
puts "Conversion complete. #{$status_message}"
f = open("#{file_name}.tiff", 'w')
f.write($image_data)
f.close

#if conversion was successful, $status_message will be "", and the ouput file will contain a standard tiff image
#readable by any image utility.

#one can exercise the decode utility independantly of ruby by executing the following command:
#
#     cat test.kob |./decode > test.tiff
