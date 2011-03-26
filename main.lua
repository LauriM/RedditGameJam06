function love.load()
	world = love.physics.newWorld(-800,-600, 800,600)
	world:setGravity(0,0)
	world:setCallbacks(persist)

	bodies = {}
	shapes = {}
	alive  = {}
	info   = {}
	tile   = {}
	kill   = {}

	emitter_alive    = {}
	emitter_x        = {}
	emitter_y        = {}
	emitter_left     = {}
	emitter_interval = {}
	emitter_tick     = {}

	MAX_OBJ     = 10000
	MAX_EMITTER = 20
	
	for i=0,MAX_OBJ do
		alive[i] = false
	end

	mouse_state_l = 0

	camera_x    = 0
	camera_y    = 0
	map_width   = 20
	map_height  = 20
	tile_size_x = 20
	tile_size_y = 20
	
	tile_count  = 2

	tile_img = {}
	for i=0,tile_count do
		tile_img[i] = love.graphics.newImage("tiles/"..i..".png")
	end

	map_background={
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	}

	map_foreground={
	   { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	}
	
	count = 0
	for x=1, map_width do
		for y=1, map_height do
			if map_foreground[x][y] > 0 then
				bodies[count] = love.physics.newBody(world,x * tile_size_x,y * tile_size_y,0,0)
				shapes[count] = love.physics.newRectangleShape(bodies[count],0, 0,20,20,0)
				alive[count]  = true
				info[count]   = 0
				tile[count]   = map_foreground[x][y]
				if tile[count] == 2 then
					shapes[count]:setData("End")
				end
				count = count + 1
			end
		end
	end

	count = 0
--	for i=0, MAX_OBJ do
--		if alive[i] == false then
--			if count < 1000 then
--				count = count + 1
--				alive[i]  = true
--				bodies[i] = love.physics.newBody(world,math.random(25,300),math.random(25,300),20,20)
--				shapes[i] = love.physics.newCircleShape(bodies[i],0,0,2)
--				info[i]   = 1
--				bodies[i]:setLinearVelocity(math.random(-25,25),math.random(-25,25))
--				shapes[i]:setData(i)
--			end
--		end
--	end

end

function love.update(dt)
	if love.keyboard.isDown("down") == true then
		world:setGravity(0,70)
	end

	if love.keyboard.isDown("up") == true then
		world:setGravity(0,-70)
	end

	if love.keyboard.isDown("right") == true then
		world:setGravity(70,0)
	end

	if love.keyboard.isDown("left") == true then
		world:setGravity(-70,0)
	end

	--remove old objects
	for i=0,MAX_OBJ do	
		if kill[i] == true then
			kill[i] = false
			alive[i] = false
			bodies[i]:destroy()
			shapes[i]:destroy()
		end
	end
	world:update(dt)
end

function persist(a,b,coll)
	if a == "End" then
		kill[b] = true
	end
end

function love.draw()
	draw_physics()
	love.graphics.print("Objects left: "..targets_left,20,2)
end

function draw_physics()
	--Lest count the object count at the same time
	targets_left = 0
	for i=0,MAX_OBJ do
		if alive[i] == true then
			if info[i] == 0 then
				if tile[i] > 0 then
					love.graphics.draw(tile_img[tile[i]], bodies[i]:getX()-10,bodies[i]:getY()-10) 
				end
			end

			if info[i] == 1 then
				love.graphics.circle("fill", bodies[i]:getX(), bodies[i]:getY(),2)
				targets_left = targets_left + 1
			end
		end
	end
end

function map_bg()
	for x=1, map_width do
		for y=1, map_height do
				love.graphics.draw(tile[map_background[x][y]], (x * tile_size_x) + camera_x - 10, (y * tile_size_y) + camera_y - 10)
		end
	end
end
