const Players = game:GetService('Players')
const ReplicatedStorage = game:GetService('ReplicatedStorage')
const RunService = game:GetService('RunService')

const promise = require(ReplicatedStorage.packages.promise)

const function promisePlayerDisconnected(player: Player): promise.TypedPromise<Player, Enum.PlayerExitReason>?
	if not player:IsDescendantOf(Players) then
		return nil
	end

	return promise.fromEvent(Players.PlayerRemoving, function(playerWholeft)
		if playerWholeft == player then
			return true
		end
		return false
	end)
end

const function getLocalPlayer()
	assert(RunService:IsClient(), 'Attempt to call client function on a server!')
	return Players.LocalPlayer
end

return {
	promisePlayerDisconnected = promisePlayerDisconnected,
	getLocalPlayer = getLocalPlayer,
}
