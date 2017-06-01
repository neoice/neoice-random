#!/usr/bin/env ruby

require 'fileutils'
require 'time'

# build our days. we use an array so we can do
# more than one day at a time if we care.
now  = DateTime.now
day  = now.strftime("%Y%m%d")
days = [ day ]

# hard-coded variables. get bent.
target_dir = "/tank/media/music/c895"
puts "[!] base directory => #{target_dir}"

# morning show
# TODO: this varies with DST!!!
dj = "drew-bailey"

# vortex
#hours = ["03", "04", "05", "06"20170529
#dj = "dj-tamm"

# common
minutes = ["0000", "1500", "3000", "4500"]

sleep 2

days.each do |x|
  ts = Time.new(x[0..3],x[4..5], x[6..7])
  day_str = ts.strftime('%A %b %d')
  day_dir = ts.strftime("%Y-%m-%d_%A").downcase

  puts "[!] ripping day #{x} #{day_str}"
  puts "[-] making directory #{day_dir}"
  FileUtils.mkdir_p "#{target_dir}/#{day_dir}"

  if ts.dst?
    hours = ["13", "14", "15", "16"]
  else
    hours = ["14", "15", "16", "17"]
  end

  hours.each do |y|
    minutes.each do |z|
      filename = "knhc_#{x}-#{y}#{z}.mp3"

      if File.file?("#{target_dir}/#{day_dir}/#{filename}")
        puts "[-] #{filename} exists, skipping."
        next
      end

      puts "[-] downloading file #{filename}..."

      # Marion, don't look at it.
      `curl 'https://s3-us-west-1.amazonaws.com/rfa-archive-dev/#{filename}' --silent -H 'Accept-Encoding: identity;q=1, *;q=0' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.radiofreeamerica.com/dj/#{dj}' -H 'Connection: keep-alive' -H 'Range: bytes=0-' --compressed > #{target_dir}/#{day_dir}/#{filename}`
    end
  end
end
