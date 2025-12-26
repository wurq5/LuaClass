--!strict
export type ClassDef = {
	[string]: any,
}

export type ClassBase<T> = T & {
	__index: ClassBase<T>,
	__className: string,
}

export type ClassConstructor<T> = {
	new: () -> ClassBase<T>,
}

export type ClassBuilder<T> = ((def: ClassDef) -> ClassConstructor<T>) & {
	extends: (self: ClassBuilder<T>, parent: ClassConstructor<any>) -> (def: ClassDef) -> ClassConstructor<T>,
}

local Class = {}

-- Private functions
local function createClass<T>(name: string, definition: ClassDef, parent: ClassConstructor<any>?): ClassConstructor<T>
	local classConstructor = {
		new = function(): ClassBase<T>
			local class = {} :: any
			class.__index = class
			class.__className = name

			if parent then
				setmetatable(class, { __index = parent })
			end

			for key, value in pairs(definition) do
				if key ~= "init" and key ~= "private" and key ~= "static" then
					class[key] = value
				end
			end

			return class :: ClassBase<T>
		end,
	}

	return classConstructor
end

local function createClassBuilder<T>(className: string): ClassBuilder<T>
	local builder = {} :: any

	setmetatable(builder, {
		__call = function(_: any, def: ClassDef): ClassConstructor<T>
			return createClass(className, def, nil)
		end,
	})

	function builder:extends(parent: ClassConstructor<any>): (def: ClassDef) -> ClassConstructor<T>
		return function(def: ClassDef): ClassConstructor<T>
			return createClass(className, def, parent)
		end
	end

	return builder :: ClassBuilder<T>
end

-- Hacky method to make API look better
setmetatable(Class, {
	__call = function<T>(_: any, className: string): ClassBuilder<T>
		return createClassBuilder(className)
	end,
})

return (Class :: any) :: <T>(className: string) -> ClassBuilder<T>
