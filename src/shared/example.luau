local Class = require(script.Parent.Class)

--stylua: ignore
local animalClass = Class "Animal" {
    Private = {
        secretNoise = "Noise!"
    },
    makeNoise = function(self)
        print(self.Private.secretNoise)
    end,
    jump = function(self)
        print("Jump!")
    end,
    init = function(self)
    end
}

--stylua: ignore
local dogClass = Class "Dog" : extends(animalClass) {
    Private = {
        Age = 0
    },
    makeNoise = function(self)
        print("Woof!")
    end,
    init = function(self)
        self.Private.Age += 1
    end
}

local dog = dogClass.new()
dog:makeNoise() -- "Woof!"
dog:jump() -- "Jump!"
