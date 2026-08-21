const ReplicatedStorage = game:GetService('ReplicatedStorage')

const vide = require(ReplicatedStorage.packages.vide)

const create = vide.create

const function app()
	return create('ScreenGui') {
		Name = 'app',
		ResetOnSpawn = false,
	}
end

return app
