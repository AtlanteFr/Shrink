local function onPlayerDamage(player, hp_change)
    if hp_change < 0 then
        minetest.chat_send_player(player:get_player_name(), minetest.colorize("Orange", "[Small Voice] You are now smaller :D"))
        
        local new_properties = player:get_properties()
        local new_shrink_count = player:get_meta():get_int("shrink_count") or 0
        
        if new_properties.visual_size.x > 0.1 and new_properties.visual_size.y > 0.1 then
            new_properties.visual_size = {x = new_properties.visual_size.x - 0.1, y = new_properties.visual_size.y - 0.1}
            new_properties.eye_height = new_properties.eye_height - 0.12
            new_properties.stepheight = new_properties.stepheight - 0.12
            --Collision box
            player:set_properties(new_properties)
            player:get_meta():set_int("shrink_count", new_shrink_count + 1)
        end
    end
end

minetest.register_on_player_hpchange(onPlayerDamage)

local function resetPlayerSize(player)
    local original_properties = player:get_properties()
    original_properties.visual_size = {x = 1.0, y = 1.0}
    original_properties.collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
    original_properties.eye_height = 1.47
    original_properties.stepheight = 0.9
    player:set_properties(original_properties)
    
    player:get_meta():set_int("shrink_count", 0)
    minetest.chat_send_player(player:get_player_name(), "Votre taille a été réinitialisée.")
end

minetest.register_chatcommand("reset_size", {
    description = "Réinitialise la taille du joueur",
    privs = {interact = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if player then
            resetPlayerSize(player)
        end
    end,
})
