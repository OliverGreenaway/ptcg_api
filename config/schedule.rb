set :output, "log/cron_log.log"
ENV.each { |k, v| env(k, v) }

every 30.minutes do
  rake 'tournaments:update'
end
