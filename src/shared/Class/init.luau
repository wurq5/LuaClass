--!strict

-- Type definitions
export type ClassDef = {
	[string]: any,
}

-- Base class type representing the prototype of an instance
export type ClassBase<T> = T & {
	__index: ClassBase<T>,
	__className: string,
}

-- Constructor type with a 'new' method that creates instances
export type ClassConstructor<T> = {
	new: (...any) -> ClassBase<T>,
}

-- Builder type that enables fluent class definition syntax
-- Can be called directly with a definition, or chained with :extends() for inheritance
export type ClassBuilder<T> = ((def: ClassDef) -> ClassConstructor<T>) & {
	extends: (self: ClassBuilder<T>, parent: ClassConstructor<any>) -> (def: ClassDef) -> ClassConstructor<T>,
}

local Class = {}

-- Private functions

local function createClass<T>(
	name: string,
	definition: ClassDef,
	parent: ClassConstructor<any>?,
	parentClassTable: any?
): ClassConstructor<T>
	local class = {} :: any
	class.__index = class
	class.__className = name

	-- Set up inheritance chain if parent exists
	if parentClassTable then
		setmetatable(class, { __index = parentClassTable })
	end

	-- Copy definition properties to class (this will override parent methods)
	for key, value in pairs(definition) do
		class[key] = value
	end

	local classConstructor = {
		new = function(...: any): ClassBase<T>
			-- Create instance from the shared class prototype
			local newInstance = setmetatable({}, class) :: any

			-- Call init if it exists
			if class.init then
				newInstance:init(...)
			end

			return newInstance :: ClassBase<T>
		end,
		__classTable = class, -- Store reference to class table for inheritance
	}

	return classConstructor
end

--- Creates a builder object that enables the fluent class definition API
--- The builder can be called directly or used with :extends() for inheritance
--- @param className The name to assign to the class
--- @return A builder that accepts class definitions
local function createClassBuilder<T>(className: string): ClassBuilder<T>
	local builder = {} :: any

	-- Make the builder callable to accept class definitions directly
	setmetatable(builder, {
		__call = function(_: any, def: ClassDef): ClassConstructor<T>
			return createClass(className, def, nil, nil)
		end,
	})

	-- Add extends method for inheritance syntax
	function builder:extends(parent: ClassConstructor<any>): (def: ClassDef) -> ClassConstructor<T>
		return function(def: ClassDef): ClassConstructor<T>
			-- Pass the parent's class table for proper inheritance
			return createClass(className, def, parent, (parent :: any).__classTable)
		end
	end

	return builder :: ClassBuilder<T>
end

-- Make the Class module callable to create class builders
-- This enables the syntax: Class "MyClass" { ... }
setmetatable(Class, {
	__call = function<T>(_: any, className: string): ClassBuilder<T>
		return createClassBuilder(className)
	end,
})

return (Class :: any) :: <T>(className: string) -> ClassBuilder<T>
