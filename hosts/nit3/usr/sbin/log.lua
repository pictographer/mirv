#!/usr/bin/env lua
-- Read one line from the USB serial port, prepend a timestamp and write
-- it to stdout.

-- Tell the serial USB serial device not to do anything extra.
assert(io.popen("stty -F /dev/ttyACM0 raw -echo -echoe -echok"))

-- Open the USB serial port.
file = assert(io.open("/dev/ttyACM0"))

-- Setup io.
io.input(file)
--io.stdout:setvbuf("no")
io.stdin:setvbuf("no")

-- Read a line.
serlux = assert(io.read("*line"))

-- Strip off line ending.
serlux = string.sub(serlux, 0, -2)

-- Print the line with a timestamp.
df = assert(io.popen("date -Iminute"))
timestamp = assert(df:read("*line"))
timestamp = string.sub(timestamp, 0, -2)
df:close()
print(string.format("%s\t%s", timestamp, serlux))

file:close()
