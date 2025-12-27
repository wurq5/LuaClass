local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage.DevPackages.TestEZ)

local results = TestEZ.TestBootstrap:run({
	ReplicatedStorage.Tests,
})

if results.failureCount > 0 then
	error("Tests failed!")
end

print("All tests passed!")
