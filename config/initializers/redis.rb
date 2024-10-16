$redis = Redis::Namespace.new("ptcg_api", :redis => Redis.new(url: ENV["REDIS_SERVER_URL"]))
