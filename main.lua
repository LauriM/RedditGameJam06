function love.load()
	state = 0
	-- 0 = menu
	-- 1 = game
	world = love.physics.newWorld(-800,-600, 800,600)
	world:setGravity(0,0)
	world:setCallbacks(persist)

	bodies = {}
	shapes = {}
	alive  = {}
	info   = {}
	tile   = {}
	kill   = {}

	emitter_alive     = {}
	emitter_x         = {}
	emitter_y         = {}
	emitter_left      = {}
	emitter_blob_size = {}

	MAX_OBJ     = 10000
	MAX_EMITTER = 20
	
	for i=0,MAX_OBJ do
		alive[i] = false
		emitter_alive[i] = false
		emitter_left[i] = 0
	end

	time = love.timer.getTime()

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

	map={
	   { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	   { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	}

	emitter_alive[1]     = true
	emitter_left[1]      = 500
	emitter_x[1]         = 50
	emitter_y[1]         = 50
	emitter_blob_size[1] = 50 

	emitter_alive[2]     = true
	emitter_left[2]      = 500
	emitter_x[2]         = 50
	emitter_y[2]         = 300
	emitter_blob_size[2] = 50 
	
	count = 0
	for x=1, map_width do
		for y=1, map_height do
			if map[x][y] > 0 then
				bodies[count] = love.physics.newBody(world,x * tile_size_x,y * tile_size_y,0,0)
				shapes[count] = love.physics.newRectangleShape(bodies[count],0, 0,20,20,0)
				alive[count]  = true
				info[count]   = 0
				tile[count]   = map[x][y]
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
if state == 0 then
end

if state == 1 then
	--input
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

	--update timers
	if love.timer.getTime() - time > 1 then
		time = love.timer.getTime()

		update_emitters()
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
end --state end

end

function persist(a,b,coll)
	if a == "End" then
		kill[b] = true
	end
end

function love.draw()
if state == 0 then
	love.graphics.print("Menu",20,20)
end
if state == 1 then
	draw_physics()
	love.graphics.print("Objects left: "..targets_left,20,2)
end
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

function update_emitters()
	for a=0, MAX_EMITTER do
		if emitter_alive[a] == true then
			count = 0
			emitter_left[a] = emitter_left[a] - emitter_blob_size[a] 
			for i=0, MAX_OBJ do
				if alive[i] == false then
					if count < emitter_blob_size[a] then
						count = count + 1
						alive[i]  = true
						bodies[i] = love.physics.newBody(world,emitter_x[a],emitter_y[a],20,20)
						shapes[i] = love.physics.newCircleShape(bodies[i],0,0,2)
						info[i]   = 1
						bodies[i]:setLinearVelocity(math.random(-25,25),math.random(-25,25))
						shapes[i]:setData(i)
					end
				end
			end

			if emitter_left[a] < 0 then
				emitter_alive[a] = false
			end

		end
	end

end
