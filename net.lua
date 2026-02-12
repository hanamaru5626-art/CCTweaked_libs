local net = {}

local modem = peripheral.find("modem")
if not modem then error("No modem found") end

local MAIN_CHANNEL = 65535
local myAddress = nil

function net.init(address)
  myAddress = address
  modem.open(MAIN_CHANNEL)
end

function net.send(to, data)
  if not myAddress then error("net not initialized") end

  modem.transmit(MAIN_CHANNEL, MAIN_CHANNEL, {
    to = to,
    from = myAddress,
    data = data
  })
end

function net.receive()
  if not myAddress then error("net not initialized") end
  while true do
    local _, _, ch, reply, msg = os.pullEvent("modem_message")
    if ch == MAIN_CHANNEL and type(msg) == "table" then
      if msg.to == myAddress then
        return msg.from, msg.to, msg.data
      end
    end
  end
end
return net
