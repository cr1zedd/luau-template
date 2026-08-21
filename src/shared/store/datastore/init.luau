const ReplicatedStorage = game:GetService('ReplicatedStorage')

const playerDataTemplate = require(script['player-data-template'])

const charm = require(ReplicatedStorage.packages.charm)

export type playerData = typeof(playerDataTemplate)

const function toUserId(player: Player): string
	return `playerData` .. player.User.Id
end

const getData, setData = charm.signal({} :: { [string]: playerData })

const function get(player)
	return getData()[toUserId(player)]
end

const function set(player, data: playerData?)
	setData(function(previous)
		local current = table.clone(previous)

		current[toUserId(player)] = data

		return current
	end)
end

const function selectData(player: Player)
	return function()
		return get(player)
	end
end

const function removeData(player: Player)
	set(player, nil)
end

const function awaitLocalData(player: Player): playerData
	const thread = coroutine.running()

	local data = get(player)

	if data then
		return data
	end

	local cleanup
	cleanup = charm.subscribe(selectData(player), function(state: playerData)
		print(state)
		if not state then
			return
		end
		(cleanup :: () -> ())()

		data = state
		task.spawn(thread)
	end)

	coroutine.yield()

	return data :: any
end

return {
	set = set,
	get = get,
	setData = setData,
	getData = getData,
	removeData = removeData,
	playerDataTemplate = playerDataTemplate,
	awaitLocalData = awaitLocalData,
	selectData = selectData,
}
