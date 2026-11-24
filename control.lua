local function localised_technology_name(tech)
    local proto = prototypes.technology[tech]
    if proto.localised_name then
        return proto.localised_name
    end
    return { "?", {"technology-name." .. tech}, {"", {"technology-name." .. string.sub(tech, 1, #tech - 2)}, " ", string.sub(tech, -1)} }
end

--translating localised strings is obnoxious! this is a hack.
local function check_string_matching(haystack, needle)
    if #needle == 0 then
        return true
    end
    needle = string.gsub(needle, " ", "-")
    if string.find(haystack, needle, 1, true) then
        return true
    end
    return false
end

local function InitForce(force)
    if not storage.force_data then
        storage.force_data = {}
    end
    if not storage.force_data[force] then
        storage.force_data[force] = {
            techs_available = {},
            points = 0
        }
    end
end

local function create_no_techs_placeholder(gui)
    local dummy = gui.add { type = "label", name = "adequate_no_tech_choices", caption = { "aa-no-tech-choices-available" }, style="frame_title" }
end

local function create_tech_effect_indicator(gui, effect, num)
    local function percent(num)
        local out = tostring(num * 100) .. "%"
        if num > 0 then
            out = "+" .. out
        end
        return out
    end

    if effect.type == "unlock-recipe" then
        local recipe_name = { "recipe-name." .. effect.recipe }
        local rec = prototypes.recipe[effect.recipe]
        if rec.localised_name then
            recipe_name = rec.localised_name
        end

        local search_text = {"", {"", recipe_name, " "}}
        for k, v in pairs(rec.products) do
            table.insert(search_text, " ")
            local proto = prototypes[v.type][v.name]
            if proto.localised_name then
                table.insert(search_text, proto.localised_name)
            elseif proto.place_result then
                table.insert(search_text, {"", {"?", "item-name." .. v.name, "entity-name" .. proto.place_result}, " "})
            else
                table.insert(search_text, {"", {v.type .. "-name." .. v.name}, " "})
            end
        end

        return gui.add { type = "sprite", name = "adequate_reward_" .. tostring(num), sprite = "recipe/" .. effect.recipe, elem_tooltip = { type = "recipe", name = effect.recipe }, tags = {search_text=search_text} }
    end
    if effect.type == "change-recipe-productivity" then
        local recipe_name = { "recipe-name." .. effect.recipe }
        local rec = prototypes.recipe[effect.recipe]
        if rec.localised_name then
            recipe_name = rec.localised_name
        end
        return gui.add { type = "sprite", name = "adequate_reward_" .. tostring(num), sprite = "recipe/" .. effect.recipe, tooltip = { "modifier-description.change-recipe-productivity", recipe_name, percent(effect.change) }, tags = {search_text=effect.recipe} }
    end
    if effect.type == "nothing" then
        local icon = "default-bonus"
        if effect.effect_description and prototypes.mod_data["adequate-alternatives-nothing-modifier-sprites"].data[effect.effect_description[1]] then
            icon = prototypes.mod_data["adequate-alternatives-nothing-modifier-sprites"].data[effect.effect_description[1]]
        end
        local sprite = gui.add { type = "sprite", name = "adequate_reward_" .. tostring(num), sprite = icon, tooltip = effect.effect_description }
        sprite.style.size = { 32, 32 }
        sprite.style.stretch_image_to_widget_size = true
        return sprite
    end
end

local function create_tech_entry(gui, tech)
    local tech_prototype = prototypes.technology[tech]

    local tech_choice = gui.add { type = "frame", name = "adequate_tech_choice_" .. tech, caption = localised_technology_name(tech), direction="vertical", style="entity_frame", tags={search_text=tech}}
    tech_choice.style.use_header_filler = false
    local basic_info = tech_choice.add { type = "flow", name = "adequate_tech_icon_and_desc", direction = "horizontal" }
    local tech_icon = basic_info.add { type = "sprite", name = "adequate_tech_icon", sprite = "technology/" .. tech }
    tech_icon.style.size = { 64, 64 }
    tech_icon.style.stretch_image_to_widget_size = true
    local desc = basic_info.add { type = "label", name = "adequate_tech_description", caption = { "?", tech_prototype.localised_description or { "INVALID TECHNOLOGY" }, { "technology-description." .. tech }, "" } }
    desc.style.single_line = false
    --desc.style.maximal_width=624
    local bottom_layer = tech_choice.add{type="flow", name="adequate_tech_bottom_row", direction="horizontal"}
    local rewards_list = bottom_layer.add { type = "flow", name = "adequate_tech_rewards_list", direction = "horizontal" }
    local button_number = 1
    local search_text = { "", { "", localised_technology_name(tech), " " } }
    for k, v in pairs(tech_prototype.effects) do
        if not v.hidden then
            local button = create_tech_effect_indicator(rewards_list, v, button_number)
            button_number = button_number + 1
            if button.tags and button.tags.search_text then
                table.insert(search_text, button.tags.search_text)
            end
        end
    end
    tech_choice.tags = {search_text=search_text}
    local space_filler = bottom_layer.add { type = "empty-widget", name = "adequate_space_filler" }
    space_filler.style.horizontally_stretchable = true
    local confirm_button = bottom_layer.add { type = "button", name = "adequate_tech_confirm_button", caption = { "aa-research-button" }, direction = "horizontal", tags = { technology = tech }, style = "confirm_button_without_tooltip" }

    return tech_choice
end

local function update_gui_with_new_techs(force, techs)
    for k, v in pairs(force.players) do
        if v.gui.screen.adequate_tech_window then
            local force_data = storage.force_data[force.name]
            v.gui.screen.adequate_tech_window.adequate_tech_points_counter.caption = { "aa-tech-points-indicator", force_data.points}

            local scroll_list = v.gui.screen.adequate_tech_window.adequate_tech_list

            if not storage.translation_requests then
                storage.translation_requests = {}
            end
            local search_texts = {}
            local antikeys = {}

            for k2, v2 in pairs(techs) do
                entry = create_tech_entry(scroll_list, v2)
                table.insert(search_texts, entry.tags.search_text)
                table.insert(antikeys, "adequate_tech_choice_" .. v2)
            end

            if #techs > 0 then
                for k2, v2 in pairs(v.request_translations(search_texts)) do
                    storage.translation_requests[v2] = antikeys[k2]
                end
            end

            if scroll_list.adequate_no_tech_choices and #techs > 0 then
                scroll_list.adequate_no_tech_choices.destroy()
            end
            for k2, v2 in pairs(scroll_list.children_names) do
                scroll_list[v2].adequate_tech_bottom_row.adequate_tech_confirm_button.enabled = force_data.points > 0
            end
        end
    end
end

local function toggle_adequate_alternatives_gui(player)
    InitForce(player.force.name)
    if player.gui.screen.adequate_tech_window then
        player.gui.screen.adequate_tech_window.destroy()
    else
        local force_data = storage.force_data[player.force.name]

        local window = player.gui.screen.add { type = "frame", name = "adequate_tech_window", direction="vertical" }
        window.style.height = 660
        window.style.width = 880
        window.auto_center = true

        local titlebar = window.add{type="flow", name="adequate_titlebar", horizontal_spacing=8}

        local window_title = titlebar.add{type="label", name="adequate_window_title", caption={"aa-gui-title"}, style="frame_title"}
        local drag_bar = titlebar.add { type = "empty-widget", style="draggable_space", name="adequate_drag_bar" }
        drag_bar.style.height = 24
        drag_bar.style.horizontally_stretchable = true
        drag_bar.style.right_margin = 4
        drag_bar.drag_target = window

        local search_container = titlebar.add{type="flow", name="adequate_search_container"}
        local close_button = titlebar.add{type="sprite-button", style="frame_action_button", sprite="utility/search", name="adequate_search_button"}
        local close_button = titlebar.add{type="sprite-button", style="frame_action_button", sprite="utility/close", name="adequate_close_button"}

        local counter = window.add{type="label", name="adequate_tech_points_counter", caption = { "aa-tech-points-indicator", force_data.points} }
        counter.style.single_line = false

        local scroll_list = window.add { type = "scroll-pane", name = "adequate_tech_list", direction="vertical", style="naked_scroll_pane" }
        scroll_list.style.vertically_stretchable = true
        local any_techs = false
        if not storage.translation_requests then
            storage.translation_requests = {}
        end
        local search_texts = {}
        local antikeys = {}
        for k, v in pairs(force_data.techs_available) do
            any_techs = true
            entry = create_tech_entry(scroll_list, k)
            entry.adequate_tech_bottom_row.adequate_tech_confirm_button.enabled = force_data.points > 0
            table.insert(search_texts, entry.tags.search_text)
            table.insert(antikeys, "adequate_tech_choice_" .. k)
        end
        if any_techs then
            for k, v in pairs(player.request_translations(search_texts)) do
                storage.translation_requests[v] = antikeys[k]
            end
        else
            create_no_techs_placeholder(scroll_list)
        end

        player.opened = window
    end
end

script.on_event(defines.events.on_string_translated, function(event)
    local player = game.get_player(event.player_index)
    local element_name = ""
    if storage.translation_requests and storage.translation_requests[event.id] then
        element_name = storage.translation_requests[event.id]
        storage.translation_requests[event.id] = nil
    end
    local window = player.gui.screen.adequate_tech_window
    if window and (element_name ~= "") and window.adequate_tech_list[element_name] then
        local tags = window.adequate_tech_list[element_name].tags
        tags.search_string = string.lower(event.result)
        window.adequate_tech_list[element_name].tags = tags
    end
end)

script.on_event("adequate-alternatives-gui-toggle", function(event)
    toggle_adequate_alternatives_gui(game.get_player(event.player_index))
end)

local function open_search_field(window)
    if window.adequate_titlebar.adequate_search_container.adequate_search_field then
        window.adequate_titlebar.adequate_search_container.adequate_search_field.focus()
        window.adequate_titlebar.adequate_search_container.adequate_search_field.select(1, #window.adequate_titlebar.adequate_search_container.adequate_search_field.text)
    else
        local textfield = window.adequate_titlebar.adequate_search_container.add { type = "textfield", style = "search_popup_textfield", name = "adequate_search_field", lose_focus_on_confirm = true }
        window.adequate_titlebar.adequate_search_button.toggled = true
        textfield.focus()
    end
end

local function close_search_field(window)
    if window.adequate_titlebar.adequate_search_container.adequate_search_field then
        window.adequate_titlebar.adequate_search_button.toggled = false
        window.adequate_titlebar.adequate_search_container.adequate_search_field.destroy()
        for k, v in pairs(window.adequate_tech_list.children_names) do
            local child = window.adequate_tech_list[v]
            child.visible = true
        end
    end
end

script.on_event("adequate-alternatives-find", function(event)
    local player = game.get_player(event.player_index)
    local window = player.gui.screen.adequate_tech_window
    if window then
        open_search_field(window)
    end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index)
    if event.element then
        if event.element.name == "adequate_tech_window" then
            event.element.destroy()
        end
    end
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
    if event.element.name == "adequate_search_field" then
        local player = game.get_player(event.player_index)
        local window = player.gui.screen.adequate_tech_window
        if window then
            local search_term = string.lower(event.element.text)
            for k, v in pairs(window.adequate_tech_list.children_names) do
                local child = window.adequate_tech_list[v]
                if child.tags.search_string then
                    child.visible = not not string.find(child.tags.search_string, search_term, 1, true)
                else
                    child.visible = true
                end
            end
        end
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "adequate_close_button" then
        event.element.parent.parent.destroy()
    elseif event.element.name == "adequate_search_button" then
        if event.element.toggled then
            close_search_field(event.element.parent.parent)
        else
            open_search_field(event.element.parent.parent)
        end
    elseif event.element.name == "adequate_tech_confirm_button" then
        local player = game.get_player(event.player_index)
        local force_data = storage.force_data[player.force.name]
        if force_data.points > 0 then
            force_data.points = force_data.points - 1
            local tech = event.element.tags.technology
            player.force.technologies[tech].researched = true
            player.force.technologies[tech].enabled = true
            force_data.techs_available[tech] = nil

            for k, v in pairs(player.force.players) do
                local window = player.gui.screen.adequate_tech_window
                if window then
                    window.adequate_tech_points_counter.caption = { "aa-tech-points-indicator", force_data.points }
                end
                window.adequate_tech_list["adequate_tech_choice_" .. tech].destroy()
                if force_data.points <= 0 then
                    for k, v in pairs(window.adequate_tech_list.children_names) do
                        window.adequate_tech_list[v].adequate_tech_bottom_row.adequate_tech_confirm_button.enabled = false
                    end
                end

                local any_techs = false
                for k, v in pairs(force_data.techs_available) do
                    any_techs = true
                    break
                end
                if not any_techs then
                    create_no_techs_placeholder(window.adequate_tech_list)
                end
                player.force.print({"aa-tech-unlock-notification", player.name, tech})
                player.force.play_sound({path="utility/research_completed"})
            end
        end
    end
end)

script.on_event(defines.events.on_research_finished, function(event)
    local res = event.research
    local force = res.force
    local weight_modifiers = prototypes.mod_data["adequate-alternatives-unlocking-techs"].data[res.name]
    --an empty list is still not nil
    if weight_modifiers then
        InitForce(force.name)
        local force_data = storage.force_data[force.name]
        force_data.points = force_data.points + 1
        local all_techs = prototypes.mod_data["adequate-alternatives-techs"].data
        local candidates = {}
        local almost_candidates = {}
        local candidate_count = 0
        for k, v in pairs(all_techs) do
            if force.technologies[k] then
                local tech = force.technologies[k]
                if tech.researched == false and not force_data.techs_available[k] then
                    local licit = true
                    for k2, v2 in pairs(tech.prerequisites or {}) do
                        if not v2.researched then
                            licit = false
                            break
                        end
                    end
                    if licit then
                        candidates[k] = v
                        candidate_count = candidate_count + 1
                    else
                        almost_candidates[k] = v
                    end
                end
            end
        end

        if candidate_count == 0 and math.random(1, 10) == 10 then
            local available_options = 0
            for k, v in pairs(force_data.techs_available) do
                available_options = available_options + 1
            end
            if available_options - force_data.points > 3 then
                force.print({ "adequate-alternatives-no-new-options" })
                update_gui_with_new_techs(force, {})
                return
            end
        end

        if candidate_count <= 2 then
            for k, v in pairs(almost_candidates) do
                candidates[k] = { name = k, weight = 1 }
                candidate_count = candidate_count + 1
            end
        end

        if candidate_count == 0 then
            force.print({ "adequate-alternatives-no-new-options" })
            update_gui_with_new_techs(force, {})
        elseif candidate_count <= 2 then
            local chosen_techs = {}
            local index = 1
            for k, v in pairs(candidates) do
                force_data.techs_available[k] = k
                force.technologies[k].visible_when_disabled = true
                chosen_techs[index] = k
                index = index + 1
            end
            if index == 2 then
                force.print({"adequate-alternatives-one-new-option", chosen_techs[1]})
            else
                force.print({"adequate-alternatives-two-new-options", chosen_techs[1], chosen_techs[2]})
            end
            update_gui_with_new_techs(force, chosen_techs)
        else
            local pool = {}
            for k, v in pairs(candidates) do
                local i = 0
                -- weight_modifiers is a list of tags e.g. demolisher analysis has the tag "vulcanus"
                -- any candidate technology with vulcanus=some number gets its weight increased by that value
                for k2, v2 in pairs(weight_modifiers) do
                    if v[v2] then
                        i = i - v[v2]
                    end
                end
                while i < (v.weight or 10) do
                    table.insert(pool, k)
                    i = i + 1
                end
            end
            local pick = pool[math.random(1, #pool)]
            force_data.techs_available[pick] = pick
            force.technologies[pick].visible_when_disabled = true

            local options = 0
            for k, v in pairs(force_data.techs_available) do
                options = options + 1
            end

            if options < 6 or (math.random(1, 2) == 2) then
                local pool = {}
                candidates[pick] = nil
                for k, v in pairs(candidates) do
                    local i = 0
                    for k2, v2 in pairs(weight_modifiers) do
                        if v[v2] then
                            i = i - v[v2]
                        end
                    end
                    while i < (v.weight or 10) do
                        table.insert(pool, k)
                        i = i + 1
                    end
                end
                local pick2 = pool[math.random(1, #pool)]
                force_data.techs_available[pick2] = pick2
                force.technologies[pick2].visible_when_disabled = true
                force.print({ "adequate-alternatives-two-new-options", pick, pick2 })
                update_gui_with_new_techs(force, {pick, pick2})
            else
                force.print({ "adequate-alternatives-one-new-option", pick })
                update_gui_with_new_techs(force, {pick})
            end
        end
    end
end)

local enemy_structures_to_track = {["biter-spawner"] = true, ["spitter-spawner"] = true, ["egg-raft"] = true}

script.on_event(defines.events.on_biter_base_built, function(event)
    if not storage.expansion_bases then
        storage.expansion_bases = {}
    end
    if event.entity.valid and enemy_structures_to_track[event.entity.name] then
        storage.expansion_bases[event.entity.unit_number] = true
    end
end)

script.on_event(defines.events.on_entity_died, function(event)
    if not storage.expansion_bases then
        storage.expansion_bases = {}
    end
    if storage.expansion_bases[event.entity.unit_number] then
        storage.expansion_bases[event.entity.unit_number] = nil
    else
        if event.entity.name == "biter-spawner" then
            event.loot.insert({ name = "royal-peanut-butter", count = 1 })
        end
        if event.entity.name == "spitter-spawner" then
            event.loot.insert({ name = "royal-jelly", count = 1 })
        end
        if event.entity.name == "egg-raft" then
            event.loot.insert({ name = "satellite", count = 1 })
        end
    end
end)

script.on_event(defines.events.on_post_entity_died, function(event)
    local found = game.surfaces[event.surface_index].find_entities_filtered { position = event.position, name = "biter-spawner" }
    if not storage.expansion_bases then
        storage.expansion_bases = {}
    end
    if found and #found then
        for k, v in pairs(found) do
            storage.expansion_bases[v.unit_number] = true
        end
    end
end, {{filter="type", type="assembling-machine"}})


script.on_configuration_changed(function(data)
    for k, v in pairs(game.players) do
        if v.gui.screen.adequate_tech_window then
            v.gui.screen.adequate_tech_window.destroy()
        end
    end

    if storage.force_data then
        for k, v in pairs(game.forces) do
            local force_data = storage.force_data[v.name]
            if force_data then
                for k2, v2 in pairs(prototypes.mod_data["adequate-alternatives-techs"].data) do
                    local tech = v.technologies[k2]
                    if tech then
                        if not tech.researched then
                            tech.enabled = false
                            if force_data.techs_available[k2] then
                                tech.visible_when_disabled = true
                            else
                                tech.visible_when_disabled = false
                            end
                        end
                    end
                end
            end
        end

        for k, v in pairs(storage.force_data) do
            for k2, v2 in pairs(v.techs_available) do
                if not prototypes.technology[k2] then
                    v.techs_available[k2] = nil
                end
            end
        end
    end
end)
