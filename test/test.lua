local netstring = dofile("../netstring.lua")

local function test(name, func)
  xpcall(function()
    func()
    print(("[pass] %s"):format(name))
  end, function(err)
    print(("[fail] %s : %s"):format(name, err))
  end)
end

local function with_input(input_data, test_func)
    local input_file = io.tmpfile()
    input_file:write(input_data)
    input_file:flush()
    input_file:seek"set"
    test_func(input_file)
    input_file:close()
end

local function with_output(test_func)
    local output_file = io.tmpfile()
    test_func(output_file)
    output_file:flush()
    output_file:seek"set"
    output = output_file:read"*a"
    output_file:close()
    return output
end

test("read sanity", function()
    with_input("12:hello world!,", function(stream)
        assert(assert(netstring.read(stream)) == "hello world!")
    end)
end)

test("write sanity", function()
    local output = with_output(function(stream)
        netstring.write(stream, "hello world!")
    end)
    assert(output == "12:hello world!,")
end)

test("read empty", function()
    with_input("0:,", function(stream)
        assert(assert(netstring.read(stream)) == "")
    end)
end)

test("multiple reads", function()
    with_input("5:hello,5:world,", function(stream)
        assert(assert(netstring.read(stream)) == "hello")
        assert(assert(netstring.read(stream)) == "world")
    end)
end)

test("multiple writes", function()
    local output = with_output(function(stream)
        netstring.write(stream, "hello")
        netstring.write(stream, "world")
    end)
    assert(output == "5:hello,5:world,")
end)

test("half read", function()
    with_input("5:hello,5:w", function(stream)
        assert(assert(netstring.read(stream)) == "hello")
        assert(netstring.read(stream) == nil)
    end)
end)

test("max length read", function()
    with_input("10:hellohello", function(stream)
        assert(netstring.read(stream, 5) == nil)
    end)
end)

test("max length write", function()
    local output = with_output(function(stream)
        assert(netstring.write(stream, "hello world!", 5) == nil)
    end)
    assert(output == "")
end)
