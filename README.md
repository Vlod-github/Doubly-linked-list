# Doubly linked list
This is an implementation of the classic two-linked list in lua.
## Example
```lua
local dl = DoublyLinkedList()
dl = DoublyLinkedList({1,2,3,4}) --> [1, 2, 3, 4]
dl:popf() --> 1, [2, 3, 4]
dl:pushf(1.5) --> [1.5, 2, 3, 4]
dl:popl() --> 4, [1.5, 2, 3]
dl:push(2, 6) --> [1.5, 2, 6, 3]
dl:sort() --> [1.5, 2, 3, 6]
print(dl[4]) --> 6
dl[1] = 1 --> [1, 2, 3, 6]
for i, v in dl:iter() do
  print(i,v) --> (1, 1), (2, 2), (3, 3), (4, 6)
end
dl:clear() --> []
```
## API
**`object:pushf(item)`**

Short for *push first*. Adds an item to the top of the list. Analogue - `object:push(0)`

**`object:pushl(item)`**

Short for *push last*. Adds the item to the end of the list. Analogue - `object:push(#object)` or `object:push(-1)`

**`object:push(int index, item)`**

Adds an item **after** the given index. If the index is set after the maximum or minimum item, it adds from the edge. Negative indexing is supported, where -1 means the last item.

**`object:popf() --> item or nil`**

Short for *pop first*. Returns the first item or nil. Analogue - `object:pop(1)`

**`object:popl() --> item or nil`**

Short for *pop last*. Returns the last item or nil. Analogue - `object:pop(#object)` or `object:pop(-1)`

**`object:pop(int index) --> item or nil`**

Removes and returns an item by index. If the index is set after the maximum or minimum item, it returns nil. Negative indexing is supported, where -1 means the last item.

**`object:clear()`**

Deletes all items in the list.

**`object:clone() --> new object`**

Creates and returns a copy of the list.

**`object:iter(boolean isReversed) --> function`**

This is an iterator that is used instead of `pairs()`

**`object:reverse() --> object`**

Reverses the order of the list items.

**`object:sort(function compire)`**

Sorts the list. By default, compire = `function(a, b) return a < b end`

**`object[int index] --> item or nil`**

Returns an item or nil by index. Negative indexing is supported, where -1 means the last item.

**`object[int index] = item`**

Replace an item by an index, if such an index exists.
## Performance analysis
All tests will be conducted on a computer with a Ryzen 5 3500U processor, which will be limited to a maximum frequency of 1.66 gigahertz.

We will compare by the following categories: create, insert, delete, copy and sort, and we will compare with the standard lua table.

Note that inserting and deleting at the beginning is the best O(1) for a list, but the worst O(N) for an array. Inserting and deleting at the end is the best O(1) for an array and the best O(1) for a list. Both insertion and deletion in the middle is the worst O(N/2) for a list and the average O(N/2) for an array.

Added a python list and a node array at the request of a friend.
### Create
We will create items from ***1 -> Count item***

To insert at the beginning
```lua
dl:pushf(value)

table.insert(tbl, 1, value)
```
```js
arr.unshift(value)
```
```python
li.insert(0, value)
```
![create mainFirst](https://user-images.githubusercontent.com/103655830/175765848-a60e9324-5497-41fc-b899-0e805ae3c581.png)
To insert in the middle
```lua
dl:push(math.floor(i/2), value)

table.insert(tbl, math.ceil(i/2), value)
```
```js
arr.splice(Math.floor(i/2), 0, value)
```
```python
li.insert(math.floor(i/2), value)
```
![create mainMean](https://user-images.githubusercontent.com/103655830/175765859-5b91c895-70f1-4368-bda5-40c04eed3ee8.png)
To insert at the end
```lua
dl:pushl(value)

table.insert(tbl, value)
```
```js
arr.push(value)
```
```python
li.append(value)
```
![create mainEnd](https://user-images.githubusercontent.com/103655830/175765866-97b10dbb-78ad-42c5-adc7-e6a952b6d301.png)
### Insert
We will expand the list by 10%. For 1000 items it is +100, for 10_000 it is + 1000.

To insert at the beginning
![insert mainFirst](https://user-images.githubusercontent.com/103655830/175765890-ee27f792-34ae-4c01-bd5e-e1581e6ff03f.png)
To insert in the middle
![insert mainMean](https://user-images.githubusercontent.com/103655830/175765901-bf68912b-dd18-4e95-81cf-47ace33725a4.png)
To insert at the end
![insert mainEnd](https://user-images.githubusercontent.com/103655830/175765908-64b24128-f871-4c66-96c5-eb8efc2aeb40.png)
### Delete
We will delete 10% of the list size. That is, from 1000 to 900 or from 10_000 to 9_000.

To remove from the beginning
```lua
dl:popf()

table.remove(tbl, 1)
```
```js
arr.shift()
```
```python
li.pop(0)
```
![remove mainFirst](https://user-images.githubusercontent.com/103655830/175765918-10f2b60e-1a3f-4102-82ef-903e0e6bb81b.png)
To remove from the middle
```lua
dl:pop(math.floor(#dl/2))

table.remove(tbl, math.floor(#tbl/2))
```
```js
arr.splice(Math.floor(arr.lenght/2), 1)
```
```python
li.pop(math.floor(len(li)/2))
```
![remove mainMean](https://user-images.githubusercontent.com/103655830/175765929-20b2d8d9-d22d-4c0e-8db4-0229e92a6a7e.png)
To remove from the end
```lua
dl:popl()

table.remove(tbl)
```
```js
arr.pop()
```
```python
li.pop()
```
![remove mainEnd](https://user-images.githubusercontent.com/103655830/175765935-4fc4bb39-b491-4ad4-ac7f-e32d935ec1b6.png)
### Сopy
We will create a copy of the list of different sizes.
```lua
local new_list = dl:clone()

local new_table = {}
for i = 1, #tbl do new_table[i] = tbl[i] end
```
```js
let newArray = arr.slice()
```
```python
new_list = list(li)
```
![clone](https://user-images.githubusercontent.com/103655830/175765948-186bde4d-d5c6-4698-bf32-ba5d55152004.png)
### Sort
We will sort the following types of data: ordered, inversely ordered, randomly ordered.
```lua
dl:sort()

table.sort(tbl)
```
```js
arr.sort()
```
```python
li.sort()
```
For ordered
![sort ordered](https://user-images.githubusercontent.com/103655830/175765957-e6834a50-ef78-4850-890b-2f9c334a9ef6.png)
For inversely ordered
![sort back ordered](https://user-images.githubusercontent.com/103655830/175765966-ba35cee2-9cd6-4a35-a97f-b3fb5ad99925.png)
For randomly ordered
![sort random](https://user-images.githubusercontent.com/103655830/175765974-a7e7f929-1927-4775-ba24-7137b22176da.png)
## Conclusions
**Only Lua**

As you can see, up to 1000 items can be used lua table without problems. In the future, try to avoid inserting at the beginning of the table. A two-linked list is inferior to a table in many ways, this is due to the fact that working with the table is implemented at the C++ level. And as for an algorithm that works in an interpreted language, the result is pretty good. A good practical application would be a case where you need to delete and add items from two edges of the list, for example, a queue.

**Total**

It's funny that each of their structures: this list, lua table, python list, node array wins in one of the situations.