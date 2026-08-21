const Players = game:GetService('Players')
const ReplicatedStorage = game:GetService('ReplicatedStorage')
const RunService = game:GetService('RunService')
const ServerScriptService = game:GetService('ServerScriptService')

const profilestore = require(ServerScriptService['server-packages'].profilestore)

const charm = require(ReplicatedStorage.packages.charm)
const datastore = require(ReplicatedStorage.shared.store.datastore)

const runtime = require(ReplicatedStorage.shared.utils.runtime)
const player_util = require(ReplicatedStorage.shared.utils['player-util'])

const PlayerStore = profilestore.New('Test', datastore.playerDataTemplate :: any)

type loadedListener = (Player, datastore.playerData) -> ()
type removingListeners = (Player, datastore.playerData) -> ()

const listeners: { [number]: loadedListener } = {}
const removingListeners: { [number]: removingListeners } = {}

const function addListener(callback: loadedListener)
	table.insert(listeners, callback)
end

const function addRemovingListener(callback: removingListeners)
	table.insert(removingListeners, callback)
end

const function handleEvents() end

const function onCharacter(character: Model)
	-- character:AddTag(tags.character)
end

const function LoadProfile(player: Player): profilestore.Profile<datastore.playerData>?
	const profile: profilestore.Profile<datastore.playerData>? =
		PlayerStore:StartSessionAsync('Player_' .. player.User.Id, {
			Cancel = function()
				return player.Parent ~= Players
			end,
		})

	if not profile then
		player:Kick('Data error occured. Please rejoin.')
		return nil
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	if not player:IsDescendantOf(Players) then
		profile:EndSession()
		return nil
	end

	profile.OnSessionEnd:Connect(function()
		player:Kick('Data error occured. Please rejoin.')
	end)

	return profile
end

const function OnPlayer(player: Player)
	const Profile = LoadProfile(player)
	if not Profile then
		return
	end

	datastore.set(player, Profile.Data)

	const cleanup = charm.subscribe(datastore.selectData(player), function(current)
		if not current then
			return
		end
		Profile.Data = current
	end)

	const promise = player_util.promisePlayerDisconnected(player)

	if not promise then
		error('No promise has been created!')
	end

	promise:andThen(function()
		RunService.Stepped:Wait()
		cleanup()
		datastore.removeData(player)
		Profile:EndSession()
	end)

	if player.Character then
		onCharacter(player.Character)
	end

	player.CharacterAdded:Connect(function(character: Model)
		onCharacter(character)
	end)

	for _, callbacks in listeners do
		task.spawn(callbacks, player, datastore.get(player))
	end
end

const function onPlayerLeaving(player: Player)
	for _, listener in removingListeners do
		task.spawn(listener, player, datastore.get(player))
	end
end

const function start()
	Players.PlayerAdded:Connect(OnPlayer)
	Players.PlayerRemoving:Connect(onPlayerLeaving)
	handleEvents()
end

return runtime.registerModule {
	start = start,
	publicFunctions = {
		addListener = addListener,
		addRemovingListener = addRemovingListener,
	},
}
