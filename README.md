# Netstring.lua
A lightweight [Netstring](https://en.wikipedia.org/wiki/Netstring) library for Lua

## Features
* Implemented in pure Lua: works with 5.1, 5.2, 5.3 and LuaJIT
* Simple implementation
* Reads and writes netstrings into any "io.file"-like stream

## Usage
#### note: This documentation is incomplete, please read function comments
The library provides the following functions:

#### netstring.read(stream[, max_length])
Read a single netstring from stream with optional maximum length max_length, decode it and return the decoded data
```lua
-- Read a single netstring from stdin
-- Note: This probebly won't work as expected in terminal
local data = netstring.read(io.stdin)
```

#### netstring.write(stream, data[, max_length])
Write data (with optional enforced length of max_length) into stream, encoded as netstring.
```lua
-- Prints "11:Hello Wire!," to stdout
netstring.write(io.stdout, "Hello Wire!")
```
