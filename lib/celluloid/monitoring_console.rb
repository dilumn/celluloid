require 'reel'

module Celluloid
	class MonitoringConsole
		include Celluloid

		EXTRA_HEADERS = { :'Access-Control-Allow-Origin' => '*' }

		def initialize

		end

		def start
			Reel::Server::HTTP.run('127.0.0.1', 3000) do |connection|
				connection.each_request do |request|
					case request.path
					when "/actorsTasks"
						actor_task(request)
					else
						puts "NO nodes"
					end
				end
			end
		end

		def actor_task(request)
			actors = []
			Celluloid.actor_system.group.each do |t|
        next unless t.role == :actor
        actors << t.actor.tasks.to_a.size
    	end
			request.respond :ok, EXTRA_HEADERS, actors.to_json
		end

	end
end
