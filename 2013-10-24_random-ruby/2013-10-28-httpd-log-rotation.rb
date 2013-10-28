#!/usr/bin/ruby -w

# apache writes it's logs using the following directives:
# ErrorLog "|/usr/sbin/rotatelogs /var/log/httpd/<%= @server_class %>.example.com.<%= @port %>-error_log.%Y-%m-%d-%H 3600"
# CustomLog "|/usr/sbin/rotatelogs /var/log/httpd/<%= @server_class %>.example.com.<%= @port %>-access_log.%Y-%m-%d-%H 3600"
# CustomLog "|/usr/sbin/rotatelogs -L /var/log/httpd/<%= @server_class %>.example.com.<%= @port %>-logstash_access /var/log/httpd/<%= @server_class %>.example.com.<%= @port %>-logstash_access.%Y-%m-%d-%H 3600" logstash_json
#
# this results in a HUGE amount of log files. logrotate is disabled because
# rotatelogs handles the rotation. however, unlike logrotate, rotatelogs
# does not handle the compression, so we do this after the fact.

$now = Time.now
LOG_PATH = "/var/log/httpd/"
LOG_CHUNKS = ["logstash_access", "access_log", "error_log"]

Dir.new(LOG_PATH).sort.each do |name|
  LOG_CHUNKS.each do |chunk|
    if name =~ /.*-#{chunk}\..*/
      name =~ /.*(\d{4})-(\d{2})-(\d{2})-(\d{2})/
      year = $1.to_i
      month = $2.to_i
      day = $3.to_i
      hour = $4.to_i

      if (day + 7) < $now.day
        `pbzip2 #{LOG_PATH}#{name}`
      end
    end
  end
end

