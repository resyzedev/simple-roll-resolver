local rollresolver = ui.new_hotkey("RAGE","Other","Roll resolver");
local state = false;
local mode = 0;

local function x()
    local x = ui.get(rollresolver);
    if x ~= state then;
        mode = mode ~= 2 and mode + 1 or 0;
        state = x;
    end;
end;

local function resolver(ent,roll)
	local _,yaw = entity.get_prop(ent, "m_angRotation");
	local pitch = 89*((2*entity.get_prop(ent, "m_flPoseParameter",12))-1);
	entity.set_prop(ent, "m_angEyeAngles", pitch, yaw, roll);
end;

client.set_event_callback("net_update_start",function()
	local e = client.current_threat();
	if e then
		for _,enemy in next, entity.get_players(true) do
			if enemy ~= e then;
				resolver(enemy,0);
			end;
		end;
		resolver(e, mode == 1 and 50 or mode == 2 and -50 or mode);
	end;
end);

client.set_event_callback("paint",function()
	x();
	if mode ~= 0 then
		renderer.indicator(132,196,20,245,mode == 1 and "ROLL RESOLVER: 50°" or "ROLL RESOLVER: -50°");
	end;
end);

client.register_esp_flag("ROLL: 50",245, 10, 10,function(player)
	return mode == 1 and player == client.current_threat() and true or false;
end);

client.register_esp_flag("ROLL: -50",245, 10, 10,function(player)
	return mode == 2 and player == client.current_threat() and true or false;
end);