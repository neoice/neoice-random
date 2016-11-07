#!/usr/bin/env ruby

require 'time'

# build our days. we use an array so we can do
# more than one day at a time if we care.
now  = DateTime.now
day  = now.strftime("%Y%m%d")
days = [ day ]

#days  = ["20160929", "20160930", "20161003",]

# hard-coded variables.
# get bent.

target_dir = "/tank/media/music/c895"

# morning show
# TODO: this varies with DST!!!
hours = ["14", "15", "16", "17"]
dj = "drew-bailey"

# vortex
#hours = ["03", "04", "05", "06"]
#dj = "adrian-woods"

# common
minutes = ["0000", "1500", "3000", "4500"]

# let's print some info first
# directory for today too
day_str = now.strftime('%A %b %d')
day_dir = now.strftime("%Y-%m-%d_%A").downcase

puts "[!] today is #{day_str}"

puts "[!] saving files to #{target_dir}"
puts "[+] making directory #{day_dir}"

sleep 2
Dir.mkdir "#{target_dir}/#{day_dir}"

days.each do |x|
  puts "[+] ripping day #{x}"
  hours.each do |y|
    minutes.each do |z|
      filename = "knhc_#{x}-#{y}#{z}.mp3"

      puts "[-] downloading file #{filename}..."

      # Marion, don't look at it.
      `curl 'https://s3-us-west-1.amazonaws.com/rfa-archive-dev/#{filename}' --silent -H 'Accept-Encoding: identity;q=1, *;q=0' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.radiofreeamerica.com/dj/#{dj}' -H 'Connection: keep-alive' -H 'Range: bytes=0-' --compressed > #{target_dir}/#{day_dir}/#{filename}`
    end
  end
end
