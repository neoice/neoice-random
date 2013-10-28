#!/usr/bin/ruby

# core
require 'logger'
require 'open3'
require 'openssl'

# gems
require 'rubygems'
require 'aws-sdk'
require 'dotenv'

# load our settings
Dotenv.load

# config
unless $AES_PASSPHRASE = ENV['AES_PASSPHRASE'] then raise ArgumentError, "no AES_PASSPHRASE provided" end
unless $BASE_PATH = ENV['BASE_PATH'] then raise ArgumentError, "no BASE_PATH provided" end
unless $WORK_PATH = ENV['WORK_PATH'] then $WORK_PATH = "#{$BASE_PATH}work/" end
unless $BUCKET_BASE_NAME = ENV['BUCKET_BASE_NAME'] then raise ArgumentError, "no BUCKET_BASE_NAME provided" end
unless $AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY'] then raise ArgumentError, "no AWS_ACCESS_KEY provided" end
unless $AWS_SECRET_KEY = ENV['AWS_SECRET_KEY'] then raise ArgumentError, "no AWS_SECRET_KEY provided" end

# AWS config
AWS.config({
  :access_key_id => $AWS_ACCESS_KEY,
  :secret_access_key => $AWS_SECRET_KEY,
})

# logging
$log = Logger.new(STDOUT)
$log.level = Logger::INFO

# get or create our bucket based on the timestamp.
# we may want to extend to using YYYYMM so we can
# more easily manage purging/rotating data.
$s3 = AWS::S3.new
$now = Time.now
$bucket_name = "#{$BUCKET_BASE_NAME}-#{$now.year}".downcase

$bucket = $s3.buckets[$bucket_name]

if not $bucket.exists?
  $bucket = $s3.buckets.create($bucket_name)
end

# process our files:
#   skip files that are currently open OR already uploaded
#   encrypt with openssl and upload it to S3
Dir.new($BASE_PATH).sort.each do |name|
  if name =~ /mysql-bin\.\d{6}/
    # set some variables based on the timestamp
    infile = "#{$BASE_PATH}#{name}"
    x = File.stat(infile)
    remote_name = "#{x.mtime.to_i}-#{name}.enc"
    outfile = "#{$WORK_PATH}#{remote_name}"

    # check if the file is open
    output = ""
    lsof = Open3::popen3("/usr/bin/lsof #{infile}") do |stdin, stdout, stderr|
      output = stdout.read
    end

    # if the file is open, skip it
    if output != ""
      $log.info "[-] skipping #{name}:open file handles exist."
      next
    end

    # if the file is already uploaded, skip it
    obj = $bucket.objects[remote_name]
    if obj.exists?
      $log.info "[-] skipping #{name}: exists as #{remote_name} on S3."
      next
    end

    # setup our encryption
    password_env_var = (0...24).map{ ('a'..'z').to_a[rand(26)] }.join.upcase
    ENV[password_env_var] = $AES_PASSPHRASE

    # openssl encryption
    $log.info "[+] encrypting #{infile} to #{outfile}"
    `/usr/bin/openssl aes-256-cbc -e -pass env:#{password_env_var} -in #{infile} -out #{outfile}`

    $log.info "[+] uploading #{outfile} as #{$bucket_name}/#{remote_name}"

    begin
      obj.write(Pathname.new("#{outfile}"))
    rescue Exception => e
      $log.error "[!] #{e}"
    end

    $log.info "[+] deleting #{outfile}"
    File.delete "#{outfile}"

  end
end
