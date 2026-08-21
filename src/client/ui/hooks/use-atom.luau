const ReplicatedStorage = game:GetService('ReplicatedStorage')

const charm = require(ReplicatedStorage.packages.charm)
const vide = require(ReplicatedStorage.packages.vide)

const function useAtom<State>(callback: () -> State): () -> State
	const state = vide.source(callback())

	const unsubscribe = charm.subscribe(callback, function(value)
		task.spawn(state :: (State) -> State, value)
	end)

	vide.cleanup(unsubscribe)

	return state
end

return useAtom
