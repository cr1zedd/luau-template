const ReplicatedStorage = game:GetService('ReplicatedStorage')
const RunService = game:GetService('RunService')

const ripple = require(ReplicatedStorage.packages.ripple)
const vide = require(ReplicatedStorage.packages.vide)

const cleanup = vide.cleanup
const source = vide.source
const createMotion = ripple.createMotion

const function useMotion<T>(initialValue: T)
	const state = source(initialValue)
	const motion = createMotion(initialValue)

	cleanup(function()
		motion:destroy()
	end)
	cleanup(RunService.Heartbeat:Connect(function(dt)
		state(motion:step(dt))
	end))

	return state, motion
end

return useMotion
