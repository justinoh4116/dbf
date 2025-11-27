-- Reads data in from UART and logs to dataflash

-- find the serial first (0) scripting serial port instance
local port = serial:find_serial(0)

if not port then
  gcs:send_text(0, "No Scripting Serial Port")
  return
end
-- begin the serial port
port:begin(115200)
port:set_flow_control(0)

gcs:send_text(0, "Load cell logging active")

-- table for strings used in decoding
local log_data = {}
local term_number = 1
local valid = true
local term

-- stores the last read values
local current_values = {}
for i = 1, 4 do
  current_values[i] = 0
end


-- counter to send text update every .5 seconds
local text_counter = 0

-- number of terms we expect in the message
local num_terms = 3
-- maximum length of terms each term we expect
local max_length = 20

-- decode a basic string
local function decode(byte)
  local char = string.char(byte)
  if char == '\r' or char == '\n' or char == ',' then

    -- decode the term, note this assumes it is a number
    log_data[term_number] = tonumber(term)
    if not log_data[term_number] then
      -- could not convert to a number, discard this message
      valid = false
    end
    term = nil

    -- not got to the end yet
    if char == ',' then
      -- move onto next term
      if term_number < num_terms then
        term_number = term_number + 1
      end
      return false
    end

    -- make sure we have the correct number of terms
    if #log_data ~= num_terms then
      valid = false
    end

    if not valid then
      log_data = {}
    end

    -- reset for the next message
    local is_valid = valid
    term_number = 1
    valid = true

    return is_valid
  end

  -- ordinary characters are added to term
  -- if we have too many terms or they are too long then don't add to them
  if term_number <= num_terms then
    if term then
      if string.len(term) < max_length then
        term = term .. char
      else
        valid = false
      end
    else
      term = char
    end
  else
    valid = false
  end

  return false
end


-- the main update function that is used to read in data from serial port
function update()
  if not port then
    gcs:send_text(0, "no Scripting Serial Port")
    return update, 100
  end

  local n_bytes = port:available()
  while n_bytes > 0 do
    local byte = port:read()
    if decode(byte) then
      -- we have got a full line
      -- write logs w/ data

      -- add airspeed to the data
      -- log_data[4] = ahrs:airspeed_EAS()

      -- care must be taken when selecting a name, must be less than four characters and not clash with an existing log type
      -- format characters specify the type of variable to be logged, see AP_Logger/README.md
      -- not all format types are supported by scripting only: i, L, e, f, n, M, B, I, E, N, and Z
      -- Note that Lua automatically adds a timestamp in micro seconds

      -- logger:write('SCR','LD_X,LD_Y,LD_Z,VAS','ffff',tostring(table.unpack(log_data)))
      logger:write('SCR','LD_X,LD_Y,LD_Z','fff',table.unpack(log_data))

      -- sets the current values to what was measured and resets log data for the next message
      current_values = log_data
      log_data = {}
    end
    n_bytes = n_bytes - 1
  end

  if (text_counter == 49) then
    gcs_text_message()
    text_counter = 0
  end

  text_counter = text_counter + 1

  return update, 10
end

-- additional function that runs periodically to update gcs via string messages
function gcs_text_message()
  gcs:send_text(6, "Current load cell and airspeed values")
  gcs:send_text(6, "LOAD_X: " .. current_values[1] .. "N")
  gcs:send_text(6, "LOAD_Y: " .. current_values[2] .. "N")
  gcs:send_text(6, "LOAD_Z: " .. current_values[3] .. "N")
  -- gcs:send_text(6, "AIRSPEED: " .. current_values[4] .. "ft/s")
  if not (arming:is_armed()) then
    gcs:send_text(6, "Logging not active, arm system to start logging to SD Card")
  else
    gcs:send_text(6, "Logging active")
  end

  gcs:send_text(6, "-----------------------------------------------------------------------------")
  return
end


return update, 10
