#!/usr/bin/ruby -w

require 'set'

# config
$src_dir = "/home/backup/db/archive"

Metadata = Struct.new(:tablename, :timestamp)

$archives = Set.new
Dir.new($src_dir).each do |name|
  if name =~ /(\w+)_(\d+)\.7z/
    $archives.add(Metadata.new($1, $2))
  end
end

$files = []
Dir.new($src_dir).each do |name|
  if name =~ /(\w+)_(\d+)\.sql/
    $files.push(Metadata.new($1, $2))
  end
end

$cannot_upload = Set.new
$files.each do |file|
  $archives.each do |archive|
    if file[:tablename] == archive[:tablename]
      # file timestamp parsing
      file[:timestamp] =~ /(\d{4})(\d{2})(\d{2})/
      fyear = $1.to_i
      fmonth = $2.to_i
      fday = $3.to_i

      # archive timestamp parsing
      archive[:timestamp] =~ /(\d{4})(\d{2})/
      ayear = $1.to_i
      amonth = $2.to_i

      if fmonth == amonth
	$cannot_upload.add(archive)
      end
    end
  end
end

$can_upload = $archives ^ $cannot_upload
puts "### can upload"
$can_upload.each do |name|
  puts name
end
