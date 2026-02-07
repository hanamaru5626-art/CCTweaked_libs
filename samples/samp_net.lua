local net = require("net")

net.init(13)

parallel.waitForAny(
    function()
        while true do
            local from, data = net.receive()
            print("\n"..from..": "..data)
        end
    end,

    function()
        while true do
            write(">")
            local text = read()
            net.send("yuuchan.com", text)
        end
    end
)
