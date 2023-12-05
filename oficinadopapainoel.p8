pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
local menu={
	options={
		"iniciar jogo",
		"opcoes",
		"creditos"
	},
	opt = 1,
	holding={
		down = false,
		up = false,
		x = false,
		z = false
	}
}

local defaults={
	factory_time = 500, -- frames
}

local player={
	sprite = 5,
	speed = 1,
	x = 63,
	y = 63,
	f = false
}

local work={
	day = 1,
	money = 0,
	score = 0,
	factory_time = defaults.factory_time,
	cycle = "day_start",
	calculated_score = false,
}

-- funcoes auxiliares
function print_center(text, y)
	local width = #text * 4
	local x = (128 - width) / 2
	print(text, x, y)
end
-->8
-- empty
-->8
-- state: menu
function update_menu()
	if btn(⬆️) and not menu.holding.up then
		menu.opt = (menu.opt - 2) % #menu.options + 1
		menu.holding.up = true
	elseif not btn(⬆️) then
		menu.holding.up = false
	end
	
	if btn(⬇️) and not menu.holding.down then
		menu.opt = menu.opt % #menu.options + 1
		menu.holding.down = true
	elseif not btn(⬇️) then
		menu.holding.down = false
	end
	
	if btn(❎) and not menu.holding.x then
		menu.holding.x = false
		if menu.opt == 1 then
			-- iniciar jogo
			change_state("game")
		elseif menu.opt == 2 then
		  -- opcoes
		elseif menu.opt == 3 then
			-- creditos
			change_state("credits")
		end
	elseif not btn(❎) then
		menu.holding.x = false
	end
end

function draw_menu()
	cls()
	map()
	for i, option in ipairs(menu.options) do
		if i == menu.opt then
			print("* " .. option, 56, 48 + i * 12, 7)
		else
			print(option, 64, 48 + i * 12, 7)
		end
	end
end
-->8
-- state: credits
function update_credits()
	if btnp(4) then
		change_state("menu")
	end
end

function draw_credits()
	cls()
	map()
	print("desenvolvido por", 8, 104)
	print("jefferson neves", 8, 112)
end
-->8
-- state: game
function update_game()
	if work.cycle == "day_start" then
		-- etapa de inicio do dia
		if btn(❎) then
			work.cycle = "working"
		end
	elseif work.cycle == "working" then
		-- expediente
		work.factory_time -= 1
		if btn(⬅️) then
			-- mover para esquerda
			player.x = player.x - player.speed
			player.f = true
		end
		
		if btn(➡️) then
			-- mover para direita
			player.x = player.x + player.speed
			player.f = false
		end
		
		if btn(⬆️) then
			-- mover para cima
			player.y = player.y - player.speed
		end
		
		if btn(⬇️) then
			-- mover para baixo
			player.y = player.y + player.speed
		end
		
		if work.factory_time <= 0 then
			work.cycle = "day_end"
		end
	elseif work.cycle == "day_end" then
		-- etapa do fim do dia
		if not work.calculated_score then
			work.day += 1
			work.factory_time = defaults.factory_time
			work.score += 100
			work.calculated_score = true
			
			player.x = 63
			player.y = 63
			player.f = false
		end
		
		if btn(❎) then
			work.cycle = "day_start"
			work.calculated_score = false
		end
	end	
end

function draw_game()
	cls()
	if work.cycle == "day_start" then
		-- etapa de inicio do dia
		map()
		print_center("dia " .. work.day, 16)
	elseif work.cycle == "working" then
		-- expediente
		map()
		print("dia " .. work.day, 8, 8)
		print("tempo " .. work.factory_time, 8, 16)
		
		spr(player.sprite, player.x, player.y, 1, 1, player.f)
	elseif work.cycle == "day_end" then
		-- etapa do fim do dia
		map()
		print_center("dia " .. work.day, 16)
		print_center("pontuacao " .. work.score, 24)
	end
end
-->8
-- definicao dos estados
local states={
	menu={
		update=update_menu,
		draw=draw_menu
	},
	credits={
		update=update_credits,
		draw=draw_credits
	},
	game={
		update=update_game,
		draw=draw_game
	}
}
local state = states.menu


function change_state(new_state)
	state = states[new_state]
	_update = state.update
	_draw	=	state.draw
end

function _init()
	state = states.menu
end

function _update()
	state.update()
end

function _draw()
	state.draw()
end
__gfx__
00000000777777777777777777777777000000000033aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000f3ffaa90033aa90000000000000000000000000000000000000000000000000000000000000000000000000
007007007000000000000000000000070000000033ff4f400f3ffaa9000000000000000000000000000000000000000000000000000000000000000000000000
0007700070000000000000000000000700000000000fffff33ff4f40000000000000000000000000000000000000000000000000000000000000000000000000
000770007000000000000000000000070000000000033f30000fffff000000000000000000000000000000000000000000000000000000000000000000000000
0070070070000000000000000000000700000000000f423f00033f30000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000003bb30000f423f000000000000000000000000000000000000000000000000000000000000000000000000
0000000070000000000000000000000700000000000500500003bb30000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777777777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000707000007770770077700770777077707770000077700770077007700000000000000007
70000000000000000000000000000000000000000000000000000000070000000700707007007000070070707070000007007070700070700000000000000007
70000000000000000000000000000000000000000000000000000000777000000700707007007000070077707700000007007070700070700000000000000007
70000000000000000000000000000000000000000000000000000000070000000700707007007000070070707070000007007070707070700000000000000007
77777777000000000000000000000000000000000000000000000000707000007770707077700770777070707070000077007700777077000000000077777777
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000770777007700770777007700000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007070707070007070700070000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007070777070007070770077700000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007070700070007070700000700000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007700700007707700777077000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000770777077707700777077700770077000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000707070007070070007007070700000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000770077007070070007007070777000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000707070007070070007007070007000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000770707077707770777007007700770000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
70000000000000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000007
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__map__
0102020202020203020202020202020300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2122222222222222212222222222222300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
