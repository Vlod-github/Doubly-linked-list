if not DoublyLinkedList then
	
local function create_first_node(self, val)
	local node = {value = val, next = nil, prev = nil}
	self.tail, self.head = node, node
	self.count = 1
end

local function pushf(self, val)
	if self.head then
		local node = {value = val, next = self.head}
		self.head.prev = node
		self.head = node
		self.count = self.count + 1
	else
		create_first_node(self, val)
	end
end

local function pushl(self, val)
	if self.tail then
		local node =  {value = val, prev = self.tail}
		self.tail.next = node
		self.tail = node
		self.count = self.count + 1
	else
		create_first_node(self, val)
	end
end

local function push(self, ind, val)
	if ind < 0 then
		ind = self.count + 1 + ind
	end
	if ind <= 0 then return self:pushf(val) end
	if ind >= self.count then self:pushl(val) end
	local node
	if ind <= self.count/2 then
		node = self.head
		for _ = 2, ind do node = node.next end
	else
		node = self.tail
		for _ = 1, self.count-ind do node = node.prev end
	end
	local newnode = {value = val, next = node.next, prev = node}
	node.next.prev = newnode
	node.next = newnode
	self.count = self.count + 1
end

local function popf(self)
	local head = self.head
	if self.count > 1 then
		local val = head.value
		head.value = nil
		head = head.next
		head.prev.next = nil
		head.prev = nil
		self.head = head
		self.count = self.count - 1
		return val
	elseif self.count == 1 then
		local val = head.value
		head.value = nil
		self.head, self.tail, self.count = false, false, 0
		return val
	end
end

local function popl(self)
	local tail = self.tail
	if self.count > 1 then
		local val = tail.value
		tail.value = nil
		tail = tail.prev
		tail.next.prev = nil
		tail.next = nil
		self.tail = tail
		self.count = self.count - 1
		return val
	elseif self.count == 1 then
		local val = tail.value
		tail.value = nil
		self.head, self.tail, self.count = false, false, 0
		return val
	end
end

local function pop(self, ind)
	if ind <= 0 then
		if ind == 0 then return end
		ind = self.count + 1 + ind
		if ind < 1 then return nil end
	elseif ind > self.count then
		return nil
	end
	if ind == 1 then return self:popf() end
	if ind == self.count then return self:popl() end
	local node
	if ind < self.count/2 then
		node = self.head
		for _ = 2, ind do node = node.next end
	else
		node = self.tail
		for _ = 1, self.count-ind do node = node.prev end
	end

	node.prev.next = node.next
	node.next.prev = node.prev
	local val = node.value
	node.next, node.prev, node.value = nil, nil, nil
	self.count = self.count - 1
	return val
end

local function clear(self)
	local node, tmp = self.head
	for i = 1, self.count do
		tmp = node.next
		node.next, node.prev, node.value = nil, nil, nil
		node = tmp
	end
	self.head, self.tail, self.count = false, false, 0
end

local function clone(self)
	local new = DoublyLinkedList()
	for _, v in pairs(self) do
		new:pushl(v)
	end
	return new
end

local function iter(self, isReversed)
	local field, i, di, border, node
	if isReverse then
		field = 'prev'
		node = {prev = self.tail}
		i, di, border = self.count+1, -1, 0
	else
		field = 'next'
		node = {next = self.head}
		i, di, border = 0, 1, self.count+1
	end
	return function()
		node = node[field]
		i = i + di
		if i == border then return end
		return i, node.value
	end
end

local function reverse(self)
	local node = self.head
	for i = 1, self.count do
		node.next, node.prev = node.prev, node.next
		node = node.prev
	end
	self.head, self.tail = self.tail, self.head
	return self
end

local function merge(func_compare, l1, count1, l2, count2)
	local result = {}
	local curr = result
	while count1 > 0 and count2 > 0 do
		if func_compare(l1.value, l2.value) then
			curr.next = l1
			count1 = count1 - 1
			l1 = l1.next
		else
			curr.next = l2
			count2 = count2 - 1
			l2 = l2.next
		end
		curr = curr.next
	end
	curr.next = count1 > 0 and l1 or l2
	return result.next
end

local function sort(list, func_compare)
	if list.count <= 1 then return list end
	func_compare = func_compare or function(a, b) return a < b end
	local st_list = {} -- stack for list
	local st_count = {[0] = math.huge} -- stack for count
	local p = 0 -- pointer for stack
	local curr = list.head
	local next
	for _ = 1, math.ceil(list.count*0.5) do
		p = p + 1
		local new = curr.next
		if new then
			next = new.next
			st_list[p] = merge(func_compare, curr, 1, new, 1)
			st_count[p] = 2
			curr = next
		else
			st_list[p] = curr
			st_count[p] = 1
		end
		while st_count[p]+1 >= st_count[p-1] do
			st_list[p-1] = merge(func_compare, st_list[p-1], st_count[p-1], st_list[p], st_count[p])
			st_count[p-1] = st_count[p-1] + st_count[p]
			p = p - 1
		end
	end
	while p > 1 do
		st_list[p-1] = merge(func_compare, st_list[p-1], st_count[p-1], st_list[p], st_count[p])
		p = p - 1
	end
	list.head = st_list[p]
	local node = list.head
	for _ = 2, list.count do node.next.prev = node; node = node.next end
	list.tail = node
	list.head.prev = nil
	list.tail.next = nil
	return list
end

local mt = {}

function mt.__index(self, ind)
	if ind <= 0 then
		if ind == 0 then return end
		ind = self.count + 1 + ind
		if ind < 1 then return nil end
	elseif ind > self.count then
		return nil
	end
	local node
	if ind < self.count/2 then
		node = self.head
		for _ = 2, ind do node = node.next end
	else
		node = self.tail
		for _ = 1, self.count-ind do node = node.prev end
	end
	return node.value
end

function mt.__newindex(self, ind, val) -- insert
	if ind <= 0 then
		if ind == 0 then return end
		ind = self.count + 1 + ind
		if ind < 1 then return end
	elseif ind > self.count then
		return
	end
	local node
	if ind < self.count/2 then
		node = self.head
		for _ = 2, ind do node = node.next end
	else
		node = self.tail
		for _ = 1, self.count-ind do node = node.prev end
	end
	node.value = val
end

function mt.__len(self) return self.count end

function DoublyLinkedList(tbl)
	local object = setmetatable({
		head = false,
		tail = false,
		count = 0,

		pushf = pushf,
		pushl = pushl,
		push = push,
		popf = popf,
		popl = popl,
		pop = pop,
		clear = clear,
		clone = clone,
		iter = iter,
		reverse = reverse,
		sort = sort,
	}, mt)
	if tbl == nil then return object end
	local count = object.count
	if type(tbl) == 'table' then
		for _, v in pairs(tbl) do
			object:pushl(v)
			count = count + 1
		end
	elseif getmetatable(tbl) == mt then
		for _, v in tbl:iter() do
			object:pushl(v)
			count = count + 1
		end
	else
		assert(false, 'argument is not type "table" or DoublyLinkedList')
	end
	object.count = count
	return object
end
end
