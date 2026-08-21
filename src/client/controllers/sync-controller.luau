const Players = game:GetService('Players')
const ReplicatedStorage = game:GetService('ReplicatedStorage')

const charmSync = require(ReplicatedStorage.packages['charm-sync'])
const datastore = require(ReplicatedStorage.shared.store.datastore)
const runtime = require(ReplicatedStorage.shared.utils.runtime)
const events_client = require(ReplicatedStorage['events-client'])

const charmClient = charmSync.client

const player = Players.LocalPlayer

const function start()
	charmClient.addSignals {
		[`playerData{player.User.Id}`] = datastore.setData,
	}
	events_client.charmSync.StatePacket.on(function(data: { { data: { [string]: any }, type: string } })
		charmClient.patch(data :: any)
	end)

	events_client.charmSync.RequestState.fire()
end

return runtime.registerModule {
	start = start,
}
