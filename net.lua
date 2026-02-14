local modem = peripheral.find("modem")
local net = {}

local CHANNEL = 0
net.address = nil

function net.init(address)
  net.address = tostring(address)
  modem.open(CHANNEL)
end

function net.send(to, data)
  if not net.address then return end
  local packet = net.address .. "|" .. tostring(to) .. "|" .. tostring(data)
  modem.transmit(CHANNEL, CHANNEL, packet)
end

function net.receive()
  while true do
    local _, _, channel, _, msg = os.pullEvent("modem_message")
    if channel == CHANNEL and type(msg) == "string" then
      local from, to, data = msg:match("^(.-)|(.-)|(.+)$")
      if to == net.address then
        return tonumber(from), tonumber(to), data
      end
    end
  end
end
return net
