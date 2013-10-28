#!/usr/bin/ruby -w

# super naive algorithm:
# just keep interval of 7 days < 28
$days_to_keep = [1,7,14,21,28]

# config
$prefix = "logdb-backup-"
$suffix = ".sql.gz.enc"
$src_dir = "/home/backup/db/"
$dst_dir = "/home/backup/db/_offsite-these/"

$now = Time.now

$log_backups = []
Dir.new($src_dir).each do |name|
  if name =~ /#{$prefix}(\d{4})(\d{2})(\d{2})#{$suffix}/
    $log_backups.push(name)
  end
end

$log_backups.sort.each do |name|
  name =~ /#{$prefix}(\d{4})(\d{2})(\d{2})#{$suffix}/
  year = $1.to_i
  month = $2.to_i
  day = $3.to_i

  if $days_to_keep.include? day
    puts "[-] moving file dated #{year} #{month} #{day}"
    File.rename "#{$src_dir}#{$prefix}#{year}#{month}#{day}#{$suffix}", "#{$dst_dir}#{$prefix}#{year}#{month}#{day}#{$suffix}"
  elsif (day + 7) < $now.day
    puts "[!] deleting file dated #{year} #{month} #{day}"
    File.delete "#{$src_dir}#{$prefix}#{year}#{month}#{day}#{$suffix}"
  end
end

Dir.new($dst_dir).each do |name|
  if name =~ /#{$prefix}(\d{4})(\d{2})(\d{2})#{$suffix}/
    year = $1.to_i
    month = $2.to_i
    day = $3.to_i
    puts "[+] uploading file #{$dst_dir}#{name}"

    _stime = Time.now
    exit_code = `/opt/s3cmd-1.1.0-beta3/s3cmd #{$dst_dir}#{name} s3://SomeS3Bucket`
    _etime = Time.now
    duration_mins = (_etime - _stime) / 60

    if exit_code != 0
      puts "[-] completed in #{duration_mins} mins"
    else
      puts "[!!!] error code #{exit_code}"
      puts "[!!!] upload duration: #{duration_mins} mins"
      exit 1
    end
  end
end

