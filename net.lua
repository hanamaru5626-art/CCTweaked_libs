local net = {}

local modem = peripheral.find("modem")
if not modem then error("No modem found") end

local MAIN_CHANNEL = 65535
local myChannel = nil

function net.init(channel)
  myChannel = channel
  modem.open(MAIN_CHANNEL)
end

function net.send(to, data)
  if not myChannel then error("net not initialized") end

  modem.transmit(MAIN_CHANNEL, myChannel, {
    to = to,
    from = myChannel,
    data = data
  })
end

function net.receive()
  if not myChannel then error("net not initialized") end
  while true do
    local _, _, ch, reply, msg = os.pullEvent("modem_message")
    if ch == MAIN_CHANNEL and type(msg) == "table" then
      if msg.to == myChannel or msg.to == nil then
        return msg.from, msg.to, msg.data
      end
    end
  end
end

return net
