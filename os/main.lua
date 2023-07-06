
screenX, screenY = term.getSize()
mainProg = true
showTime = true

-- Tables
-- t_osStuff table contains the stuff that will appear on the desktop
t_osStuff = {
	{text = "-------", option = "startMenu", x = 1, y = screenY - 1, textCol = colours.black, bgCol = colours.blue},
	{text = "|Start|", option = "startMenu", x = 1, y = screenY, textCol = colours.black, bgCol = colours.blue},
	{text = "-------", option = "startMenu", x = 1, y = screenY - 1, textCol = colours.black, bgCol = colours.blue}
}
-- t_startMenu is the stuff that will appear for when start is clicked,
-- Also contains the other stuff within it, like the help and programs menu.
t_startMenu = {
	["main"] = {
		{text = "Programs", option = "programsMenu", x = 2, y = 11, textCol = colours.black, bgCol = colours.white},
		{text = "Help", option = "helpMenu", x = 2, y = 12, textCol = colours.black, bgCol = colours.white},
		{text = "Reboot", option = function() os.reboot() end, x = 13, y = 17, textCol = colours.white, bgCol = colours.black},
		{text = "Shutdown", option = function() os.reboot() end, x = 13, y = 20, textCol = colours.white, bgCol = colours.black}
	}
	["helpMenu"] = {
		textCol = colours.black,
		bgCol = colours.white,
		mainText = "Help",
		text = {
			"How to Uptade ?",
			"Run this command pastebin get t4jifMJn OR reinstall os without deleting files !",
            "Discord ?",
            "Yes : https://discord.gg/QtPUaPzSDY"
		}
	},
	["programsMenu"] = {
		textCol = colours.black,
		bgCol = colours.white,
		mainText = "Apps",
		startX = 3,
		startY = 3,
		programs = {
			{text = "Strafe", path = "app/strafe"},
			{text = "WhereIsDan", path = "os/screensaver/WhereIsDan"},
			{text = "Firewolf", path = "app/firewolf"},
		
            {text = "Calc", path = "os/calc"},
		}
	}
}

--[[ Functions ]] --

--[[ isValidMouseClick function:
	Takes: table, which key to return within that table, x value
		   and y value.
	Returns: true if valid click for that table with the key,
			 false and nil if not.
	Basically, it loops through a specified table and checks to see
	if the specified x and y values match up with the ones with the
	table plus the length of the text for precision.
--]]
function isValidMouseClick(_table, _returnKey, mx, my)
	for _, v in pairs(_table) do
		if mx >= v.x and mx < v.x + #v.text
		and my == v.y then
			return true, v[_returnKey]
		end
	end
	return false, nil
end

--[[ popupMenu function is used when you rightclick
	 while at the desktop for a list of options to
	 pop up.
	 Takes: x and y values, background colour, text
		    colour and the arguments (which are the
			options)
	 Returns: the selected option
--]]

function popupMenu(x, y, _bgColour, _textColour, ...)
	bgCol = _bgColour or colours.black
	textCol = _textColour or colours.white
	local args = {...}
	l = 0
	for i = 1, #args do
		if l < #args[i] then
			l = (#args[i] + 4)
		end
	end
	local objects = {}
	local bMenuDown = (y + 3 + #args) <= screenY
	local bMenuRight = (x + l - 2) <= screenX
	startX = bMenuRight and x or (x - l + 2)
	startY = bMenuDown and y or (y - (#args + 1))
	for i,v in pairs(args) do
		objects[i] = {
			x = startX + 1;
			y = i + startY;
			text = v;
			}
	end
	term.setBackgroundColour(bgCol)
	term.setCursorPos(startX-1, startY)
	write(string.rep(" ", l))
	term.setCursorPos(startX-1, startY+#objects+1)
	write(string.rep(" ", l))
	term.setTextColour(textCol)
	for _, option in pairs(objects) do
		term.setCursorPos(startX - 1, option.y)
		write(string.rep(" ", l))
		term.setCursorPos(option.x, option.y)
		term.write(option.text)
	end
	local _, button, mx, my = os.pullEvent('mouse_click')
	return isValidMouseClick(objects, "text", mx, my)
end

--[[ drawMainOS function is for drawing the desktop
	 of the program with all the colours etc.
--]]

function drawMainOS()
	term.setBackgroundColour(colours.grey)
	term.clear()
	sTime = textutils.formatTime(os.time(), false)
		term.setCursorPos(screenX - #sTime - 2, 1)
	term.setTextColour(colours.white)
	write(sTime)
	term.setCursorPos(3, 1)
	term.setTextColour(colours.lightBlue)
	write("PlinuX BETA")
	term.setBackgroundColour(colours.red)
	term.setCursorPos(1, 2)
	write(string.rep(" ", screenX))
	term.setCursorPos(1, screenY - 1)
	write(string.rep(" ", screenX))
	term.setCursorPos(1, screenY)
	write(string.rep(" ", screenX))
	for _, tab in pairs(t_osStuff) do
		term.setCursorPos(tab.x, tab.y)
		term.setTextColour(tab.textCol)
		term.setBackgroundColour(tab.bgCol)
		write(tab.text)
	end
end

--[[ MC_time function for the time at the
	 top right
--]]
function MC_time()
	while true do
		if showTime then
			sTime = textutils.formatTime(os.time(), false)
			term.setCursorPos(screenX - #sTime - 2, 1)
			term.setTextColour(colours.white)
			term.setBackgroundColour(colours.grey)
			write(sTime)
			sleep(1)
		else sleep(5) end
	end
end

local function cWrite(...)
  local curColor
  for i=1, #arg do -- arg is ...
    if type(arg[i]) == 'number' then
      curColor = arg[i]
    else
      if curColor then
        term.setTextColor(curColor)
      end
      write(arg[i])
    end
  end
end

--[[ startMenu function is for when the bottom
	 left is clicked (the start button). This
	 displays various things, such as 'Programs',
	 'Help', and 'Reboot' and all do their own thing.
--]]

function startMenu()
	for y = 10, screenY - 2 do
		for x = 1, 20 do
			term.setBackgroundColour( (x >= 1 and x <= 10) and colours.white or colours.black)
			term.setCursorPos(x, y)
			write(" ")
		end
	end
	term.setBackgroundColour(colours.white)
	for _, tab in pairs(t_startMenu["main"]) do -- prints all text for the start menu
		term.setCursorPos(tab.x, tab.y)
		term.setTextColour(tab.textCol)
		term.setBackgroundColour(tab.bgCol)
		write(tab.text)
	end
	--[[ This loop waits for a click within the start-up
		menu. It waits until a click is performed on one
		of the options or if the click is outside the menu,
		which it thens returns to the main OS screen.
		If an option is clicked, it then performs that
		option
	--]]
	local running = true
	while running do
		local _, button, x, y = os.pullEventRaw("mouse_click")
		bValidClick, option = isValidMouseClick(t_startMenu["main"], "option", x, y)
		if bValidClick then
			if type(option) == "function" then
				option()
			else
				term.setBackgroundColour(t_startMenu[option].bgCol)
				term.clear()
				term.setBackgroundColour(colours.red)
				term.setCursorPos(screenX, 1)
				write("X")
				term.setBackgroundColour(colours.grey)
				term.setCursorPos(1, 1)
				write(string.rep(" ", screenX-1))
				term.setTextColour(colours.lightBlue)
				term.setCursorPos(2, 1)
				write(t_startMenu[option].mainText)
				if option == "programsMenu" then
					local yPos = 1
					while true do
						for i = 3, screenY do
							term.setBackgroundColour(t_startMenu["programsMenu"].bgCol)
							term.setCursorPos(t_startMenu["programsMenu"].startX, i)
							if t_startMenu["programsMenu"].programs[yPos + i - 3] then
								term.clearLine()
								cWrite(colours.red, "[", colours.yellow, "RUN", colours.red, "]  ", t_startMenu["programsMenu"].textCol, t_startMenu["programsMenu"].programs[yPos + i - 3].text)
							else break end
						end
						ev, button, x, y = os.pullEvent()
						if ev == "mouse_scroll" then
							if button == -1 and yPos > 1 then
								yPos = yPos - 1
							elseif button == 1 and yPos < (#t_startMenu["programsMenu"].programs - (screenY - 3)) then
								yPos = yPos + 1
							end
						elseif ev == "mouse_click" then
							if button == 1 and x == screenX and y == 1 then
								running = false
								break
							elseif button == 1 and x >= 3 and x <= 7 and y >= 3 then
								showTime = false
								term.setBackgroundColour(colours.black) term.setTextColour(colours.white) term.clear()
								sleep(1)
								if fs.exists(t_startMenu["programsMenu"].programs[y + yPos - 3].path) then
									shell.run(t_startMenu["programsMenu"].programs[y + yPos - 3].path)
								else
									error("Invalid file: " .. t_startMenu["programsMenu"].programs[y + yPos - 3].path)
								end
								running = false
								showTime = true
								break
							end
						end
					end
				else
					local scroll = option == "helpMenu"
					if scroll then
						local yPos = 1
						while true do
							term.setTextColour(t_startMenu[option].textCol)
							term.setBackgroundColour(t_startMenu[option].bgCol)
							for i = 2, screenY do
								term.setCursorPos(1, i)
								term.clearLine()
								if not t_startMenu[option].text[yPos + i - 2] then break
								else write(t_startMenu[option].text[yPos + i - 2]) end
							end
							local ev, button, x, y = os.pullEvent()
							if ev == "mouse_scroll" then
								if button == -1 and yPos > 1 then
									yPos = yPos - 1
								elseif button == 1 and yPos <= (#t_startMenu[option].text - (screenY - 4)) then
									yPos = yPos + 1
								end
							elseif ev == "mouse_click" then
								if button == 1 and x == screenX and y == 1 then
									running = false
									break
								end
							end
						end
					end
				end
			end
		else
			if not (x >= 1 and x <= 20 and y >= 10 and y <= screenY - 2) then
				running = false
			end
		end
	end
end

function main()
	while mainProg do
		drawMainOS()
		e = {os.pullEventRaw()}
		if e[1] == "mouse_click" then
			if e[2] == 2 and e[4] >= 3 and e[4] <= screenY - 2 then -- brings up Popup menu
				bValidClick, option = popupMenu(e[3], e[4], colours.black, colours.lightBlue, "Hello", "World ", "!")
				--[[ Add an if, elseif, end statement here for
					 each option and what it must do
				--]]
			elseif e[2] == 1 then
				bMouseClick, option = isValidMouseClick(t_osStuff, "option", e[3], e[4]) -- checks to see if the position clicked is a valid area
				if bMouseClick then
					if option == "startMenu" then
						startMenu()
					end
				end
			end
		elseif e[1] == "terminate" then
			term.setCursorPos(1, 1)
			term.setBackgroundColour(colours.black)
			term.clear()
			term.setTextColour(colours.red)
			print("Terminated\n")
			term.setTextColour(colours.white)
			mainProg = false
		end
	end
end

if not term.isColor() then
	print("ERROR : FAILED TO START RAISON : THIS PROGRAM REQUIRE A ADVANCED COMPUTER !")
	return
end

parallel.waitForAny(main, MC_time)
