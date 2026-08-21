const ReplicatedStorage = game:GetService('ReplicatedStorage')

const app = require(ReplicatedStorage.client.ui.app)
const vide = require(ReplicatedStorage.packages.vide)
const datastore = require(ReplicatedStorage.shared.store.datastore)
const runtime = require(ReplicatedStorage.shared.utils.runtime)
const player_util = require(ReplicatedStorage.shared.utils['player-util'])

const player = player_util.getLocalPlayer()
const mount = vide.mount

const function start()
	datastore.awaitLocalData(player)
	mount(app, player:WaitForChild('PlayerGui'))
end

return runtime.registerModule {
	start = start,
}
