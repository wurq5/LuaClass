-- Generated tests
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Class = require(ReplicatedStorage.Shared.Class)

return function()
	describe("Class creation", function()
		it("should create a basic class", function()
			local MyClass = Class("MyClass")({
				value = 10,
				getValue = function(self)
					return self.value
				end,
			})

			local instance = MyClass.new()
			expect(instance.value).to.equal(10)
			expect(instance:getValue()).to.equal(10)
		end)

		it("should set __className property", function()
			local MyClass = Class("TestClass")({})
			local instance = MyClass.new()

			expect(instance.__className).to.equal("TestClass")
		end)

		it("should create multiple independent instances", function()
			local Counter = Class("Counter")({
				count = 0,
				increment = function(self)
					self.count = self.count + 1
				end,
			})

			local counter1 = Counter.new()
			local counter2 = Counter.new()

			counter1:increment()
			counter1:increment()

			expect(counter1.count).to.equal(2)
			expect(counter2.count).to.equal(0)
		end)
	end)

	describe("Initialization", function()
		it("should call init method on construction", function()
			local initCalled = false
			local passedValue = nil

			local MyClass = Class("MyClass")({
				init = function(self, value)
					initCalled = true
					passedValue = value
					self.initialized = true
				end,
			})

			local instance = MyClass.new(42)

			expect(initCalled).to.equal(true)
			expect(passedValue).to.equal(42)
			expect(instance.initialized).to.equal(true)
		end)

		it("should work without init method", function()
			local MyClass = Class("MyClass")({
				value = 5,
			})

			expect(function()
				local instance = MyClass.new()
				expect(instance.value).to.equal(5)
			end).never.to.throw()
		end)

		it("should pass multiple arguments to init", function()
			local receivedArgs = {}

			local MyClass = Class("MyClass")({
				init = function(self, a, b, c)
					receivedArgs = { a, b, c }
				end,
			})

			MyClass.new("foo", "bar", "baz")

			expect(receivedArgs[1]).to.equal("foo")
			expect(receivedArgs[2]).to.equal("bar")
			expect(receivedArgs[3]).to.equal("baz")
		end)
	end)

	describe("Inheritance", function()
		it("should inherit methods from parent class", function()
			local Animal = Class("Animal")({
				speak = function(self)
					return "..."
				end,
				jump = function(self)
					return "jump"
				end,
			})

			local Dog = Class("Dog"):extends(Animal)({
				speak = function(self)
					return "Woof!"
				end,
			})

			local dog = Dog.new()

			expect(dog:speak()).to.equal("Woof!")
			expect(dog:jump()).to.equal("jump")
		end)

		it("should maintain separate instances across inheritance", function()
			local Animal = Class("Animal")({
				name = "Unknown",
			})

			local Dog = Class("Dog"):extends(Animal)({
				breed = "Mixed",
			})

			local dog1 = Dog.new()
			local dog2 = Dog.new()

			dog1.name = "Buddy"
			dog1.breed = "Golden Retriever"

			expect(dog1.name).to.equal("Buddy")
			expect(dog2.name).to.equal("Unknown")
			expect(dog2.breed).to.equal("Mixed")
		end)

		it("should call child init, not parent init", function()
			local parentInitCalled = false
			local childInitCalled = false

			local Parent = Class("Parent")({
				init = function(self)
					parentInitCalled = true
				end,
			})

			local Child = Class("Child"):extends(Parent)({
				init = function(self)
					childInitCalled = true
				end,
			})

			Child.new()

			expect(childInitCalled).to.equal(true)
			expect(parentInitCalled).to.equal(false)
		end)

		it("should support multi-level inheritance", function()
			local GrandParent = Class("GrandParent")({
				method1 = function(self)
					return "gp"
				end,
			})

			local Parent = Class("Parent"):extends(GrandParent)({
				method2 = function(self)
					return "p"
				end,
			})

			local Child = Class("Child"):extends(Parent)({
				method3 = function(self)
					return "c"
				end,
			})

			local instance = Child.new()

			expect(instance:method1()).to.equal("gp")
			expect(instance:method2()).to.equal("p")
			expect(instance:method3()).to.equal("c")
		end)
	end)

	describe("Private properties", function()
		it("should allow Private property as convention", function()
			local MyClass = Class("MyClass")({
				Private = {
					secret = "hidden",
				},
				getSecret = function(self)
					return self.Private.secret
				end,
			})

			local instance = MyClass.new()

			expect(instance:getSecret()).to.equal("hidden")
			expect(instance.Private.secret).to.equal("hidden")
		end)

		it("should allow modifying Private properties", function()
			local MyClass = Class("MyClass")({
				Private = {
					value = 0,
				},
				increment = function(self)
					self.Private.value = self.Private.value + 1
				end,
			})

			local instance = MyClass.new()
			instance:increment()
			instance:increment()

			expect(instance.Private.value).to.equal(2)
		end)
	end)

	describe("Edge cases", function()
		it("should handle empty class definition", function()
			local EmptyClass = Class("Empty")({})

			expect(function()
				local instance = EmptyClass.new()
				expect(instance.__className).to.equal("Empty")
			end).never.to.throw()
		end)

		it("should allow functions as properties", function()
			local utilFunction = function(x)
				return x * 2
			end

			local MyClass = Class("MyClass")({
				util = utilFunction,
			})

			local instance = MyClass.new()
			expect(instance.util(5)).to.equal(10)
		end)

		it("should preserve table properties", function()
			local MyClass = Class("MyClass")({
				config = {
					setting1 = true,
					setting2 = "value",
				},
			})

			local instance = MyClass.new()

			expect(instance.config.setting1).to.equal(true)
			expect(instance.config.setting2).to.equal("value")
		end)
	end)
end
