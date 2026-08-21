const ReplicatedStorage = game:GetService('ReplicatedStorage')

const runtime = require(ReplicatedStorage.shared.utils.runtime)

const add_path = runtime.addPath

const directory = script

add_path(directory, 'controllers')
add_path(directory, 'components')

runtime.start()
