# LuaClass

A simple implementation of classes in Luau

## Features

-   A simplistic API similar to that of other languages (TS/JS)
-   Lightweight
-   Inheritance
-   Strictly typed

## API example

```luau
local Class = require(...)

local AnimalClass = Class "Animal" {
    Private = {
        noiseString = "Noise!"
    },

    init = function(self)
        -- do something when created
    end,

    makeNoise = function(self
        print(self.Private.noiseString)
    end,
}

local DogClass = Class "Dog" : extends(AnimalClass) {
    Private = {
        breed = "Labrador",
        noiseString = "Bark!"
    },

    getBreed = function(self)
        return self.Private.breed
    end
}

local Animal = AnimalClass.new()
local Dog = DogClass.new()

Animal:makeNoise() -- prints "Noise!"
Dog:makeNoise() -- prints "Bark! as the value is overwritten in DogClass but inherits the function from AnimalClass
print(Dog:getBreed()) -- prints "Labrador"
```

## Where to get
You can download it via
```bash
wally add wurq5/LuaClass
wally install
```
