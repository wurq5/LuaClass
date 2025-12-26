local Class = require(script.Parent.Class)

--stylua: ignore
local animalClass = Class "Animal" {
	makeNoise = function(self)
		print("Noise!")
	end,

	jump = function(self)
		print("Jump!")
	end,
}

--stylua: ignore
local dogClass = Class "Dog" : extends(animalClass) {
	makeNoise = function(self)
		print("Woof!")
	end,
}

local dog = dogClass.new()

dog:makeNoise() -- "Woof!" | Defined in Dog
dog:jump() -- "Jump!" | Inherited from Animal
