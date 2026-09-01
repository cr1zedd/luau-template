const requiredModules: { [number]: Module } = {}

type settings<T = {}> = {
	read publicFunctions: T,
	read start: () -> (),
	read priority: number?,
}

type Module<T = {}> = settings<T>

const noValueMessage = `Module code did not return exactly one value`

const function safeRequire(module: ModuleScript): Module
	const status, value = xpcall(require, function(message)
		if message == noValueMessage then
			return `Did you forgot to call registerModule? \n in {module:GetFullName()}`
		end

		return message
	end, module)

	if not status then
		const traceback = debug.traceback(coroutine.running(), value .. `{module:GetFullName()}`, 2)
		error(traceback, 2)
	end
	return value
end

const function addPath(directory: Instance, folder: string)
	const path = directory:FindFirstChild(folder)
	if not path then
		error(`Directory folder cannot be found {folder}`)
	end
	for _, module: ModuleScript in path:GetChildren() do
		if not module:IsA('ModuleScript') then
			continue
		end

		table.insert(requiredModules, safeRequire(module))
	end
end

const function start()
	table.sort(requiredModules, function(a: Module, b: Module)
		const a_priority = a.priority or 1
		const b_priority = b.priority or 1
		return a_priority > b_priority
	end)

	for _, module in requiredModules do
		task.spawn(module.start)
	end
end

const function registerModule<T>(settings: Module<T>): Module<T>
	return {
		start = settings.start or function() end,
		priority = settings.priority or 1,
		publicFunctions = settings.publicFunctions or {},
	}
end

return {
	addPath = addPath,
	safeRequire = safeRequire,
	start = start,
	registerModule = registerModule,
}
