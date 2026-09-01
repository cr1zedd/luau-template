const ReplicatedStorage = game:GetService('ReplicatedStorage')
const ServerScriptService = game:GetService('ServerScriptService')

const charm = require(ReplicatedStorage.packages.charm)
const player_service = require(script.Parent['player-service'])
const eventsServer = require(ServerScriptService['events-server'])
const charmSync = require(ReplicatedStorage.packages['charm-sync'])
const datastore = require(ReplicatedStorage.shared.store.datastore)
const runtime = require(ReplicatedStorage.shared.utils.runtime)

const charmServer = charmSync.server

const computed = charm.computed

const function start()
	eventsServer.charmSync.RequestState.on(function(player: Player)
		charmServer.addSignalsToClient(player, {
			[`playerData{player.User.Id}`] = computed(function()
				return datastore.get(player)
			end),
		})
	end)

	player_service.publicFunctions.addRemovingListener(function(player: Player)
		charmServer.removeClient(player)
	end)

	charmServer.connect(function(client, payloads)
		eventsServer.charmSync.StatePacket.fire(client, payloads)
	end)
end

return runtime.registerModule {
	start = start,
}
