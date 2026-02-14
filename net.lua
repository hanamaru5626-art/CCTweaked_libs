local net = {}

local modem = peripheral.find("modem")
local MAIN_CHANNEL = 0
local myChannel = nil

function net.init(channel)
    myChannel = channel
    modem.open(myChannel)
end
function net.send(to, data)
    if not myChannel then
        error("net not initialized")
    end
    modem.transmit(MAIN_CHANNEL, myChannel, {
        to = to,
        from = myChannel,
        data = data
    })
end

function net.receive()
    if not myChannel then
        error("net not initialized")
    end
    while true do
        local _, _, ch, reply, msg = os.pullEvent("modem_message")
        if ch == myChannel and type(msg) == "table" then
            return msg.from, msg.data
        end
    end
end
return net
