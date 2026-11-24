local sludge_pickup = {filename = "__base__/sound/creatures/spitter-spit-end-2.ogg", volume=0.6}
local sludge_drop = {filename = "__base__/sound/creatures/projectile-acid-burn-1.ogg", volume=0.7}
local item_sounds = require("__base__/prototypes/item_sounds")
local rm = require("__pf-functions__/recipe-manipulation")
local tm = require("__pf-functions__/technology-manipulation")

local function localised_technology_name(tech)
    local proto = data.raw.technology[tech]
    if proto.localised_name then
        return proto.localised_name
    end
    return { "?", {"technology-name." .. tech}, {"", {"technology-name." .. string.sub(tech, 1, #tech - 2)}, " ", string.sub(tech, -1)} }
end

data:extend({
    {
        type = "mod-data",
        name = "adequate-alternatives-techs",
        data = {
            ["steel-rod"] = {name="steel-rod", weight=10, early=5},
            ["wooden-rail"] = {name="wooden-rail", weight=5, early=5, gleba=5},
            ["steel-pipe"] = {name="steel-pipe", weight=10, early=5},
            ["raw-concrete"] = {name="raw-concrete", weight=10, early=5},
            ["insulated-wire"] = {name="insulated-wire", weight=10},
            ["stone-circuit"] = {name="stone-circuit", weight=10, early=5, fulgora=5},
            ["modern-circuit"] = {name="modern-circuit", weight=10, nauvis=3, fulgora=5},
            ["coked-steel"] = {name="coked-steel", weight=10, vulcanus=5},
            ["difference-engine"] = {name="difference-engine", weight=5, vulcanus=5},
            ["cloud-computing"] = {name="cloud-computing", weight=5, fulgora=5},
            ["oil-cut-gear"] = {name="oil-cut-gear", weight=10, fulgora=5},
            ["oil-cut-wire"] = {name="oil-cut-wire", weight=10, fulgora=5},
            ["fuel-polymerization"] = {name="fuel-polymerization", weight=10, gleba=5},
            ["oil-hacking"] = {name="oil-hacking", weight=10, gleba=5},
            ["liquid-coalifaction"] = {name="liquid-coalifaction", weight=10, gleba=5, vulcanus=5},
            ["low-density-stickture"] = {name="low-density-stickture", weight=10, vulcanus=5},
            ["actual-automation-science"] = {name="actual-automation-science", weight=10, nauvis=5},
            ["fast-logistic-science"] = {name="fast-logistic-science", weight=10, vulcanus=5},
            ["chemical-industry-pack"] = {name="chemical-industry-pack", weight=10, gleba=5},
            ["industrial-logistic-science"] = {name="industrial-logistic-science", weight=10, nauvis=5},
            ["shield-testing"] = {name="shield-testing", weight=5, late=5, combat=5},
            ["pumped-power-storage"] = {name="pumped-power-storage", weight=5, fulgora=5, early=5},
            ["solar-field"] = {name="solar-field", weight=5, fulgora=5},
            ["scientific-robots"] = {name="scientific-robots", weight=5, fulgora=5},
            ["the-needs-of-the-many"] = {name="the-needs-of-the-many", weight=5, fulgora=5},
            ["charged-furnace"] = {name="charged-furnace", weight=8, fulgora=5, vulcanus=5, late=5},
            ["microwave-furnace"] = {name="microwave-furnace", weight=8, fulgora=5, late=5},
            ["hand-assembler"] = {name="hand-assembler", weight=5, nauvis=5},
            ["linkage-inserter"] = {name="linkage-inserter", weight=5, nauvis=5, early=5},
            ["public-transportation"] = {name="public-transportation", weight=5, late=5},
            ["pipe-bomb"] = {name="pipe-bomb", weight=10, combat=10, gleba=5},
            ["grenade-propelled-rocket"] = {name="grenade-propelled-rocket", weight=5, combat=1, gleba=5},
            ["copper-magazine"] = {name="copper-magazine", weight=10, combat=10},
            ["engine-transport-belt"] = {name="engine-transport-belt", weight=5, vulcanus=10},
            ["electric-engine-transport-belt"] = {name="electric-engine-transport-belt", weight=5, vulcanus=10},
            ["rainbowport"] = {name="rainbowport", weight=5, late=5},
            ["hippie-module"] = {name="hippie-module", weight=5, early=5, nauvis=5, gleba=5},
            ["mechanical-module"] = { name = "mechanical-module", weight = 5, nauvis = 5, gleba = 5 },
            ["coke-module"] = {name="coke-module", weight=5, early=5, nauvis=5, vulcanus=5},
            ["production-module"] = { name = "production-module", weight = 5, nauvis = 5, fulgora = 5 },
            ["standardised-modules"] = {name="standardised-modules", weight=10, fulgora=10},
        }
    },
    {
        type = "mod-data",
        name = "adequate-alternatives-unlocking-techs",
        data = {
            ["biter-nest-analysis"] = {"nauvis", "early"},
            ["demolisher-analysis"] = {"vulcanus"},
            ["precursor-analysis"] = {"fulgora"},
            ["pentapod-analysis"] = {"gleba", "combat"},
            ["deep-space-analysis"] = {"late"},
            ["chemical-science-pack"] = {"early"},
            ["military-science-pack"] = {"combat", "combat", "combat"},
            ["production-science-pack"] = {},
            ["utility-science-pack"] = {},
            ["space-science-pack"] = {},
            ["metallurgic-science-pack"] = {"vulcanus", "vulcanus", "vulcanus"},
            ["electromagnetic-science-pack"] = {"fulgora", "fulgora", "fulgora"},
            ["agricultural-science-pack"] = {"gleba", "gleba", "gleba"},
            ["cryogenic-science-pack"] = {"late"},
            ["promethium-science-pack"] = {"late"},
        }
    },
    {
        type = "mod-data",
        name = "adequate-alternatives-nothing-modifier-sprites",
        data = {
            ["adequate-alternatives-still-gets-productivity"] = "aa-productivity-up"
        }
    },
    {
        type = "sprite",
        name = "aa-productivity-up",
        filename = "__AdequateAlternatives__/graphics/icons/productivity-up.png",
        size=64
    },
    {
        type = "sprite",
        name = "default-bonus",
        filename = "__core__/graphics/bonus-icon.png",
        size=32
    },
    {
        type = "technology",
        name = "bio-anomaly-studies",
        icon = "__AdequateAlternatives__/graphics/technology/biter-nest-analysis.png",
        icon_size = 256,
        prerequisites = {"automation-2"},
        unit = {
            time = 15,
            count = 50,
            ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        } },
        effects = {
            {type="unlock-recipe", recipe="biter-nest-data"},
            {type="unlock-recipe", recipe="peanut-butter-to-jelly"},
            {type="unlock-recipe", recipe="jelly-to-peanut-butter"}
        }
    },
    {
        type = "technology",
        name = "biter-nest-analysis",
        icon = "__AdequateAlternatives__/graphics/technology/biter-nest-analysis.png",
        icon_size = 256,
        upgrade = true,
        max_level = "infinite",
        prerequisites = {"bio-anomaly-studies"},
        unit = { time = 1, count_formula = "1 + ((L-1) * 2)", ingredients = {{"biter-nest-data", 1}} },
        ignore_tech_cost_multiplier = true,
        effects = {
            {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}},
            {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}},
        }
    },
    {
        type = "technology",
        name = "deep-space-analysis",
        icon = "__AdequateAlternatives__/graphics/technology/deep-space-analysis.png",
        icon_size = 256,
        upgrade = true,
        max_level = "infinite",
        prerequisites = {mods["space-age"] and "promethium-science-pack" or "space-science-pack"},
        unit = {
            time = 30,
            count_formula = "(2^L)*500",
            ingredients = mods["space-age"] and {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1},
                {"space-science-pack", 1},
                {"metallurgic-science-pack", 1},
                {"electromagnetic-science-pack", 1},
                {"agricultural-science-pack", 1},
                {"cryogenic-science-pack", 1},
                {"promethium-science-pack", 1},
            } or {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
                {"production-science-pack", 1},
                {"utility-science-pack", 1},
                {"space-science-pack", 1}
            } },
        effects = {
            {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}},
            {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}},
        }
    },
    {
        type = "custom-input",
        name = "adequate-alternatives-gui-toggle",
        key_sequence = "I",
        order = "a"
    },
    {
        type = "custom-input",
        name = "adequate-alternatives-find",
        key_sequence = "",
        linked_game_control = "focus-search"
    },
    {
        type = "item",
        name = "dummy-tech-point",
        stack_size = 100,
        icon = "__AdequateAlternatives__/graphics/icons/tech-point.png",
        icon_size = 64,
        hidden = true,
        hidden_in_factoriopedia = true
    },
    {
        type = "item-subgroup",
        name = "aa-science-items",
        group = "intermediate-products",
        order = "yz"
    },
    {
        type = "item",
        name = "royal-jelly",
        stack_size = 5,
        icon = "__AdequateAlternatives__/graphics/icons/royal-jelly.png",
        subgroup = "aa-science-items",
        order = "a",
        flags = {"always-show"},
        icon_size = 64,
        auto_recycle=false,
        moved_to_hub_when_building = true,
        pick_sound = sludge_pickup,
        drop_sound = sludge_drop,
        inventory_move_sound = sludge_drop,
        weight = 100*kg
    },
    {
        type = "item",
        name = "royal-peanut-butter",
        stack_size = 5,
        icon = "__AdequateAlternatives__/graphics/icons/royal-peanut-butter.png",
        subgroup = "aa-science-items",
        order = "b",
        flags = {"always-show"},
        icon_size = 64,
        auto_recycle=false,
        moved_to_hub_when_building = true,
        pick_sound = sludge_pickup,
        drop_sound = sludge_drop,
        inventory_move_sound = sludge_drop,
        weight = 100*kg
    },
    {
        type = "item",
        name = "biter-nest-data",
        stack_size = 100,
        icon = "__AdequateAlternatives__/graphics/icons/biter-nest-data.png",
        subgroup = "aa-science-items",
        order = "c",
        icon_size = 64,
        auto_recycle=false,
        moved_to_hub_when_building = true,
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
        weight = 100*kg
    },
    {
        type = "recipe",
        name = "biter-nest-data",
        categories = {"crafting"},
        enabled = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            {type="item", name="royal-jelly", amount=1},
            {type="item", name="royal-peanut-butter", amount=1},
            {type="item", name="automation-science-pack", amount=50},
            {type="item", name="logistic-science-pack", amount=50},
        },
        results = {
            {type="item", name="biter-nest-data", amount=1}
        }
    },
    {
        type = "recipe",
        name = "jelly-to-peanut-butter",
        icons = {
            {
                icon = "__AdequateAlternatives__/graphics/icons/royal-peanut-butter.png",
                icon_size = 64
            },
            {
                icon = "__AdequateAlternatives__/graphics/icons/royal-jelly.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        allow_decomposition = false,
        allow_as_intermediate = false,
        enabled = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            {type="item", name="royal-jelly", amount=3}
        },
        results = {
            {type="item", name="royal-peanut-butter", amount=1}
        }
    },
    {
        type = "recipe",
        name = "peanut-butter-to-jelly",
        icons = {
            {
                icon = "__AdequateAlternatives__/graphics/icons/royal-jelly.png",
                icon_size = 64
            },
            {
                icon = "__AdequateAlternatives__/graphics/icons/royal-peanut-butter.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        allow_decomposition = false,
        allow_as_intermediate = false,
        enabled = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            {type="item", name="royal-peanut-butter", amount=3}
        },
        results = {
            {type="item", name="royal-jelly", amount=1}
        }
    }
})

local lab = table.deepcopy(data.raw.lab.lab)
lab.name = "adequate-alternatives-dummy-lab"
lab.hidden = true
lab.hidden_in_factoriopedia = true
lab.minable = nil
lab.inputs = { "dummy-tech-point" }
data:extend({lab})

if mods["space-age"] then
    rm.AddRecipeCategory("peanut-butter-to-jelly", "organic")
    rm.AddRecipeCategory("jelly-to-peanut-butter", "organic")
    rm.AddRecipeCategory("biter-data", "organic")
    data.raw.technology["biter-nest-analysis"].max_level = 10
    data:extend({
        {
            type = "item",
            name = "worm-guts",
            stack_size = 5,
            icon = "__AdequateAlternatives__/graphics/icons/worm-guts.png",
            subgroup = "aa-science-items",
            order = "d",
            flags = {"always-show"},
            icon_size = 64,
            moved_to_hub_when_building = true,
            auto_recycle=false,
            pick_sound = sludge_pickup,
            drop_sound = sludge_drop,
            inventory_move_sound = sludge_drop,
            weight = 1001*kg
        },
        {
            type = "item",
            name = "demolisher-data",
            stack_size = 100,
            icon = "__AdequateAlternatives__/graphics/icons/demolisher-data.png",
            subgroup = "aa-science-items",
            order = "e",
            icon_size = 64,
            moved_to_hub_when_building = true,
            auto_recycle=false,
            inventory_move_sound = item_sounds.electric_small_inventory_move,
            pick_sound = item_sounds.electric_small_inventory_pickup,
            drop_sound = item_sounds.electric_small_inventory_move,
            weight = 200*kg
        },
        {
            type = "recipe",
            name = "demolisher-data",
            categories = {"metallurgy"},
            enabled = false,
            energy_required = 60,
            auto_recycle=false,
            ingredients = {
                {type="item", name="worm-guts", amount=4},
                {type="item", name="production-science-pack", amount=100},
                {type="item", name="metallurgic-science-pack", amount=500}
            },
            surface_conditions = {
              {property="pressure", min=4000, max=4000}
            },
            results = {
                {type="item", name="demolisher-data", amount=1}
            }
        },
        {
            type = "technology",
            name = "demolisher-studies",
            icon = "__AdequateAlternatives__/graphics/technology/demolisher-analysis.png",
            icon_size = 256,
            prerequisites = {"metallurgic-science-pack", "production-science-pack", "bio-anomaly-studies"},
            unit = {
                time = 30,
                count = 1000,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1},
                    {"space-science-pack", 1},
                    {"metallurgic-science-pack", 1},
                }
                },
            effects = {
                {type="unlock-recipe", recipe="demolisher-data"}
            }
        },
        {
            type = "technology",
            name = "demolisher-analysis",
            icon = "__AdequateAlternatives__/graphics/technology/demolisher-analysis.png",
            icon_size = 256,
            prerequisites = { "demolisher-studies" },
            upgrade = true,
            max_level = "infinite",
            unit = {
                time = 30,
                count_formula = "2*L",
                ingredients = {
                    {"demolisher-data", 2},
                    {"biter-nest-data", 1}
                }
                },
            ignore_tech_cost_multiplier = true,
            effects = {
                {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}},
                {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}},
            }
        },
        {
            type = "item",
            name = "gene-vault",
            stack_size = 5,
            icon = "__AdequateAlternatives__/graphics/icons/gene-vault.png",
            subgroup = "aa-science-items",
            order = "f",
            flags = {"always-show"},
            icon_size = 64,
            moved_to_hub_when_building = true,
            auto_recycle=false,
            inventory_move_sound = item_sounds.metal_large_inventory_move,
            pick_sound = item_sounds.metal_large_inventory_pickup,
            drop_sound = item_sounds.metal_large_inventory_move,
            weight = 1001*kg
        },
        {
            type = "item",
            name = "precursor-data",
            stack_size = 100,
            icon = "__AdequateAlternatives__/graphics/icons/precursor-data.png",
            subgroup = "aa-science-items",
            order = "g",
            icon_size = 64,
            moved_to_hub_when_building = true,
            auto_recycle=false,
            inventory_move_sound = item_sounds.electric_small_inventory_move,
            pick_sound = item_sounds.electric_small_inventory_pickup,
            drop_sound = item_sounds.electric_small_inventory_move,
            weight = 200*kg
        },
        {
            type = "recipe",
            name = "precursor-data",
            categories = {"electromagnetics"},
            enabled = false,
            energy_required = 60,
            auto_recycle=false,
            ingredients = {
                {type="item", name="gene-vault", amount=1},
                {type="item", name="utility-science-pack", amount=100},
                {type="item", name="electromagnetic-science-pack", amount=500}
            },
            surface_conditions = {
              {property="magnetic-field", min=99}
            },
            results = {
                {type="item", name="precursor-data", amount=1}
            }
        },
        {
            type = "technology",
            name = "precursor-studies",
            icon = "__AdequateAlternatives__/graphics/technology/precursor-analysis.png",
            icon_size = 256,
            prerequisites = {"electromagnetic-science-pack", "utility-science-pack", "bio-anomaly-studies"},
            unit = {
                time = 30,
                count = 1000,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"utility-science-pack", 1},
                    {"space-science-pack", 1},
                    {"electromagnetic-science-pack", 1},
                }
                },
            effects = {
                {type="unlock-recipe", recipe="precursor-data"}
            }
        },
        {
            type = "technology",
            name = "precursor-analysis",
            icon = "__AdequateAlternatives__/graphics/technology/precursor-analysis.png",
            icon_size = 256,
            prerequisites = { "precursor-studies" },
            upgrade = true,
            max_level = "infinite",
            unit = {
                time = 30,
                count_formula = "2*L",
                ingredients = {
                    {"precursor-data", 1},
                    {"biter-nest-data", 1}
                }
                },
            ignore_tech_cost_multiplier = true,
            effects = {
                {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}},
                {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}},
            }
        },
        {
            type = "item",
            name = "primordial-pho",
            stack_size = 5,
            icon = "__AdequateAlternatives__/graphics/icons/primordial-pho.png",
            subgroup = "aa-science-items",
            order = "h",
            flags = {"always-show"},
            icon_size = 64,
            moved_to_hub_when_building = true,
            auto_recycle=false,
            inventory_move_sound = item_sounds.electric_small_inventory_move,
            pick_sound = item_sounds.electric_small_inventory_pickup,
            drop_sound = item_sounds.electric_small_inventory_move,
            weight = 1001*kg
        },
        {
            type = "item",
            name = "pentapod-data",
            stack_size = 100,
            icon = "__AdequateAlternatives__/graphics/icons/pentapod-data.png",
            subgroup = "aa-science-items",
            order = "i",
            icon_size = 64,
            moved_to_hub_when_building = true,
            auto_recycle=false,
            pick_sound = sludge_pickup,
            drop_sound = sludge_drop,
            inventory_move_sound = sludge_drop,
            weight = 200*kg
        },
        {
            type = "recipe",
            name = "biter-nest-data-from-eggs",
            icons = {
                {
                    icon = "__AdequateAlternatives__/graphics/icons/biter-nest-data.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/biter-egg.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = {"organic"},
            enabled = false,
            energy_required = 60,
            auto_recycle=false,
            ingredients = {
                {type="item", name="biter-egg", amount=1000},
                {type="item", name="automation-science-pack", amount=100},
                {type="item", name="logistic-science-pack", amount=100},
                {type="item", name="chemical-science-pack", amount=100},
            },
            results = {
                {type="item", name="biter-nest-data", amount=1}
            }
        },
        {
            type = "technology",
            name = "captive-biter-nest-analysis",
            icon = "__AdequateAlternatives__/graphics/technology/biter-nest-analysis.png",
            icon_size = 256,
            prerequisites = {"biter-egg-handling"},
            unit = {
                time = 30,
                count = 1000,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"military-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"production-science-pack", 1},
                    {"utility-science-pack", 1},
                    {"space-science-pack", 1},
                    {"agricultural-science-pack", 1},
                }
                },
            effects = {
                {type="unlock-recipe", recipe="biter-nest-data-from-eggs"}
            }
        },
        {
            type = "recipe",
            name = "pentapod-data",
            categories = {"organic"},
            energy_required = 60,
            auto_recycle=false,
            ingredients = {
                {type="item", name="primordial-pho", amount=1},
                {type="item", name="military-science-pack", amount=100},
                {type="item", name="agricultural-science-pack", amount=500}
            },
            surface_conditions = {
              {property="pressure", min=2000, max=2000}
            },
            results = {
                {type="item", name="pentapod-data", amount=1}
            }
        },
        {
            type = "technology",
            name = "pentapod-studies",
            icon = "__AdequateAlternatives__/graphics/technology/pentapod-analysis.png",
            icon_size = 256,
            prerequisites = {"agricultural-science-pack", "military-science-pack", "bio-anomaly-studies"},
            unit = {
                time = 30,
                count = 1000,
                ingredients = {
                    {"automation-science-pack", 1},
                    {"logistic-science-pack", 1},
                    {"military-science-pack", 1},
                    {"chemical-science-pack", 1},
                    {"space-science-pack", 1},
                    {"agricultural-science-pack", 1},
                }
                },
            effects = {
                {type="unlock-recipe", recipe="pentapod-data"}
            }
        },
        {
            type = "technology",
            name = "pentapod-analysis",
            icon = "__AdequateAlternatives__/graphics/technology/pentapod-analysis.png",
            icon_size = 256,
            prerequisites = { "pentapod-studies" },
            upgrade = true,
            max_level = "infinite",
            unit = {
                time = 30,
                count_formula = "3*L",
                ingredients = {
                    {"pentapod-data", 1},
                    {"biter-nest-data", 1}
                }
                },
            ignore_tech_cost_multiplier = true,
            effects = {
                {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}},
                {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}},
            }
        }
    })
else
    data:extend({
        {
            type = "recipe",
            name = "advanced-biter-nest-data",
            categories = {"crafting"},
            enabled = false,
            energy_required = 20,
            auto_recycle=false,
            ingredients = {
                {type="item", name="royal-jelly", amount=1},
                {type="item", name="royal-peanut-butter", amount=1},
                {type="item", name="automation-science-pack", amount=100},
                {type="item", name="logistic-science-pack", amount=100},
                {type="item", name="military-science-pack", amount=100},
                {type="item", name="chemical-science-pack", amount=100},
            },
            results = {
                {type="item", name="biter-nest-data", amount=2}
            }
        },
        {
            type = "technology",
            name = "advanced-anomaly-studies",
            icon = "__AdequateAlternatives__/graphics/technology/biter-nest-analysis.png",
            icon_size = 256,
            prerequisites = {"bio-anomaly-studies", "military-science-pack", "chemical-science-pack"},
            unit = {
                time = 30,
                count = 150,
                ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
            } },
            effects = {
                {type="unlock-recipe", recipe="advanced-biter-nest-data"}
            }
        },
    })
end

data:extend({
    {
        type = "recipe",
        name = "steel-rod",
        categories = { "advanced-crafting" },
        icons = {
            {
                icon = "__base__/graphics/icons/iron-stick.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/steel-plate.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        enabled = false,
        energy_required = 2.5,
        allow_as_intermediate = false,
        allow_decomposition = false,
        auto_recycle=false,
        ingredients = {
            {type="item", name="steel-plate", amount=1}
        },
        results = {
            {type="item", name="iron-stick", amount=mods["space-age"] and 12 or 10}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "steel-rod",
        icon = "__base__/graphics/technology/steel-processing.png",
        icon_size = 256,
        prerequisites = {"steel-processing"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="steel-rod"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "wooden-rail",
        categories = { "advanced-crafting" },
        icons = {
            {
                icon = "__base__/graphics/icons/rail.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/wood.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        enabled = false,
        energy_required = 0.5,
        allow_as_intermediate = false,
        allow_decomposition = false,
        auto_recycle=false,
        ingredients = {
            {type="item", name="steel-plate", amount=1},
            {type="item", name="stone", amount=1},
            {type="item", name="wood", amount=1}
        },
        results = {
            {type="item", name="rail", amount=2}
        }
    },
    {
        type = "technology",
        name = "wooden-rail",
        icon = "__base__/graphics/technology/railway.png",
        icon_size = 256,
        prerequisites = {"railway"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="wooden-rail"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "steel-pipe",
        categories = { "advanced-crafting" },
        icons = {
            {
                icon = "__base__/graphics/icons/pipe.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/steel-plate.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        enabled = false,
        energy_required = 2.5,
        allow_as_intermediate = false,
        allow_decomposition = false,
        auto_recycle=false,
        ingredients = {
            {type="item", name="steel-plate", amount=1}
        },
        results = {
            {type="item", name="pipe", amount=6}
        }
    },
    {
        type = "technology",
        name = "steel-pipe",
        icon = "__base__/graphics/technology/fluid-handling.png",
        icon_size = 256,
        prerequisites = {"steel-processing"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="steel-pipe"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "raw-concrete",
        icons = {
            {
                icon = "__base__/graphics/icons/concrete.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/stone.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "stone", amount = 10 },
            { type = "item", name = "iron-stick", amount = 1 },
            { type = "fluid", name = "water", amount = 150 },
        },
        results = {
            {type="item", name="concrete", amount=10}
        }
    },
    {
        type = "technology",
        name = "raw-concrete",
        icon = "__base__/graphics/icons/concrete.png",
        icon_size = 64,
        prerequisites = {"automation-2"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="raw-concrete"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "insulated-wire",
        icons = {
            {
                icon = "__base__/graphics/icons/copper-cable.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/plastic-bar.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "advanced-crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 2,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-plate", amount = 2 },
            { type = "item", name = "plastic-bar", amount = 1 }
        },
        results = {
            {type="item", name="copper-cable", amount=6}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "insulated-wire",
        icon = "__base__/graphics/technology/electronics.png",
        icon_size = 256,
        prerequisites = {"plastics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="insulated-wire"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "stone-circuit",
        icons = {
            {
                icon = "__base__/graphics/icons/electronic-circuit.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/stone-brick.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-cable", amount = 10 },
            { type = "item", name = "stone-brick", amount = 1 }
        },
        results = {
            {type="item", name="electronic-circuit", amount=3}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "stone-circuit",
        icon = "__base__/graphics/technology/electronics.png",
        icon_size = 256,
        prerequisites = {"electronics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="stone-circuit"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "modern-circuit",
        icons = {
            {
                icon = "__base__/graphics/icons/electronic-circuit.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/plastic-bar.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 2,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-cable", amount = 5 },
            { type = "item", name = "plastic-bar", amount = 1 },
            { type = "fluid", name = "sulfuric-acid", amount = 1 }
        },
        results = {
            {type="item", name="electronic-circuit", amount=2}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "modern-circuit",
        icon = "__base__/graphics/technology/electronics.png",
        icon_size = 256,
        prerequisites = {"plastics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="modern-circuit"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "coked-steel",
        icons = {
            {
                icon = "__base__/graphics/icons/steel-plate.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/solid-fuel.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "chemistry" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 16,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "iron-plate", amount = 8 },
            { type = "item", name = "solid-fuel", amount = 1 },
            { type = "fluid", name = "steam", amount = 10 }
        },
        results = {
            {type="item", name="steel-plate", amount=2}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "coked-steel",
        icon = "__base__/graphics/technology/steel-processing.png",
        icon_size = 256,
        prerequisites = {"plastics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="coked-steel"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "difference-engine",
        icons = {
            {
                icon = "__base__/graphics/icons/processing-unit.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/iron-gear-wheel.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-plate", amount = 10 },
            { type = "item", name = "iron-stick", amount = 20 },
            { type = "item", name = "iron-gear-wheel", amount = 20 },
            { type = "fluid", name = "lubricant", amount = 20 }
        },
        results = {
            {type="item", name="processing-unit", amount=1}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "difference-engine",
        icon = "__base__/graphics/technology/processing-unit.png",
        icon_size = 256,
        prerequisites = {"lubricant"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="difference-engine"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "offsite-processor",
        icons = {
            {
                icon = "__base__/graphics/icons/advanced-circuit.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/big-electric-pole.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 45,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "electronic-circuit", amount = 15 },
            { type = "item", name = "big-electric-pole", amount = 1 },
            { type = "item", name = "processing-unit", amount = 1 }
        },
        results = {
            {type="item", name="advanced-circuit", amount=15}
        }
    },
    {
        type = "technology",
        name = "cloud-computing",
        icon = "__base__/graphics/technology/processing-unit.png",
        icon_size = 256,
        prerequisites = {"lubricant"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="offsite-processor"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "oil-cut-gear",
        icons = {
            {
                icon = "__base__/graphics/icons/iron-gear-wheel.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fluid/lubricant.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "steel-plate", amount = 1 },
            { type = "fluid", name = "lubricant", amount = 1 }
        },
        results = {
            {type="item", name="iron-gear-wheel", amount=3}
        },
        allow_productivity = true,
    },
    {
        type = "technology",
        name = "oil-cut-gear",
        icon = "__base__/graphics/technology/lubricant.png",
        icon_size = 256,
        prerequisites = {"lubricant"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="oil-cut-gear"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "oil-cut-wire",
        icons = {
            {
                icon = "__base__/graphics/icons/copper-cable.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fluid/lubricant.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-plate", amount = 3 },
            { type = "fluid", name = "lubricant", amount = 1 }
        },
        results = {
            {type="item", name="copper-cable", amount=7}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "oil-cut-wire",
        icon = "__base__/graphics/technology/lubricant.png",
        icon_size = 256,
        prerequisites = {"lubricant"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="oil-cut-wire"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "fuel-polymerization",
        icons = {
            {
                icon = "__base__/graphics/icons/plastic-bar.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/solid-fuel.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "chemistry" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "solid-fuel", amount = 1 },
            { type = "fluid", name = "petroleum-gas", amount = 25 }
        },
        results = {
            {type="item", name="plastic-bar", amount=2}
        },
        crafting_machine_tint = data.raw.recipe["plastic-bar"].crafting_machine_tint,
        allow_productivity = true
    },
    {
        type = "technology",
        name = "fuel-polymerization",
        icon = "__base__/graphics/technology/plastics.png",
        icon_size = 256,
        prerequisites = {"plastics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="fuel-polymerization"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "petroleum-gas-hacking-to-light-oil",
        icons = {
            {
                icon = "__base__/graphics/icons/fluid/petroleum-gas.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fluid/light-oil.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, 8}
            },
            {
                icon = "__base__/graphics/icons/fluid/light-oil.png",
                icon_size = 64,
                scale = 0.25,
                shift = {-8, 8}
            },
            {
                icon = "__base__/graphics/icons/electronic-circuit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        subgroup = "fluid-recipes",
        order = "b[fluid-chemistry]-b[light-oil-hacking]",
        categories = { "chemistry" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 4,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "electronic-circuit", amount = 1 },
            { type = "fluid", name = "petroleum-gas", amount = 100 }
        },
        results = {
            {type="fluid", name="light-oil", amount=mods["space-age"] and 50 or 70},
            {type="fluid", name="water", amount=50}
        },
        crafting_machine_tint = { -- direct copy-paste from base game but swap liquid and smoke colors
            tertiary = {r = 0.764, g = 0.596, b = 0.780, a = 1.000}, -- #c298c6ff
            quaternary = {r = 0.762, g = 0.551, b = 0.844, a = 1.000}, -- #c28cd7ff
            primary = {r = 0.895, g = 0.773, b = 0.596, a = 1.000}, -- #e4c597ff
            secondary = {r = 1.000, g = 0.734, b = 0.290, a = 1.000}, -- #ffbb49ff
        },
        main_product = "light-oil"
    },
    {
        type = "recipe",
        name = "light-oil-hacking-to-heavy-oil",
        icons = {
            {
                icon = "__base__/graphics/icons/fluid/light-oil.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fluid/heavy-oil.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, 8}
            },
            {
                icon = "__base__/graphics/icons/fluid/heavy-oil.png",
                icon_size = 64,
                scale = 0.25,
                shift = {-8, 8}
            },
            {
                icon = "__base__/graphics/icons/electronic-circuit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        subgroup = "fluid-recipes",
        order = "b[fluid-chemistry]-a[heavy-oil-hacking]",
        categories = { "chemistry" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 4,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "electronic-circuit", amount = 1 },
            { type = "fluid", name = "light-oil", amount = 100 }
        },
        results = {
            {type="fluid", name="heavy-oil", amount=mods["space-age"] and 50 or 70},
            {type="fluid", name="water", amount=50}
        },
        crafting_machine_tint = { -- direct copy-paste from base game but swap liquid and smoke colors
            tertiary = {r = 1.000, g = 0.642, b = 0.261, a = 1.000}, -- #ffa342ff
            quaternary = {r = 1.000, g = 0.722, b = 0.376, a = 1.000}, -- #ffb85fff
            primary = {r = 0.854, g = 0.659, b = 0.576, a = 1.000}, -- #d9a892ff
            secondary = {r = 1.000, g = 0.494, b = 0.271, a = 1.000}, -- #ff7e45ff
        },
        main_product = "heavy-oil"
    },
    {
        type = "technology",
        name = "oil-hacking",
        icon = "__base__/graphics/technology/advanced-oil-processing.png",
        icon_size = 256,
        prerequisites = {"advanced-oil-processing"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="petroleum-gas-hacking-to-light-oil"},
            {type = "unlock-recipe", recipe="light-oil-hacking-to-heavy-oil"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "liquid-coalifaction",
        icons = {
            {
                icon = "__base__/graphics/icons/coal.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fluid/heavy-oil.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        subgroup = "fluid-recipes",
        order = "a[oil-processing]-e[liquid-coalifaction]",
        categories = { "oil-processing" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "fluid", name = "heavy-oil", amount = 250 },
            { type = "fluid", name = "water", amount = 100 },
            { type = "item", name = "sulfur", amount = 1 },
        },
        results = {
            {type="item", name="coal", amount=10},
            {type="fluid", name="light-oil", amount=10},
            {type="fluid", name="steam", amount=20},
            {type="fluid", name="lubricant", amount=10}
        },
        crafting_machine_tint = {
            primary = {0.2, 0.1, 0.1}
        },
        allow_productivity = not mods["quality"]
    },
    {
        type = "technology",
        name = "liquid-coalifaction",
        icon = "__base__/graphics/technology/coal-liquefaction.png",
        icon_size = 256,
        prerequisites = {"advanced-oil-processing"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="liquid-coalifaction"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "actual-automation-science",
        icons = {
            {
                icon = "__base__/graphics/icons/automation-science-pack.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/assembling-machine-1.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 50,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "assembling-machine-1", amount = 1 },
            { type = "item", name = "copper-cable", amount = 10 },
        },
        results = {
            {type="item", name="automation-science-pack", amount=10}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "actual-automation-science",
        icon = "__base__/graphics/technology/automation-science-pack.png",
        icon_size = 256,
        prerequisites = {"automation"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="actual-automation-science"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "fast-logistic-science",
        icons = {
            {
                icon = "__base__/graphics/icons/logistic-science-pack.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fast-transport-belt.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 20,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "fast-transport-belt", amount = 1 },
            { type = "item", name = "fast-inserter", amount = 1 },
        },
        results = {
            {type="item", name="logistic-science-pack", amount=4}
        },
        allow_productivity = true
    },
    {
        type = "technology",
        name = "fast-logistic-science",
        icon = "__base__/graphics/technology/logistic-science-pack.png",
        icon_size = 256,
        prerequisites = {"logistics-2"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="fast-logistic-science"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "chemical-industry-pack",
        icons = {
            {
                icon = "__base__/graphics/icons/chemical-science-pack.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/chemical-plant.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 24,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "chemical-plant", amount = 1 },
            { type = "item", name = "battery", amount = 5 },
            { type = "item", name = "efficiency-module", amount = 1 },
        },
        results = {
            {type="item", name="chemical-science-pack", amount=4},
            {type="item", name="production-science-pack", amount=1}
        },
        main_product = "chemical-science-pack",
        allow_productivity = true
    },
    {
        type = "technology",
        name = "chemical-industry-pack",
        icon = "__base__/graphics/technology/chemical-science-pack.png",
        icon_size = 256,
        prerequisites = {"chemical-science-pack"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="chemical-industry-pack"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "industrial-logistic-science",
        icons = {
            {
                icon = "__base__/graphics/icons/production-science-pack.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/locomotive.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 100,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "locomotive", amount = 1 },
            { type = "item", name = "roboport", amount = 1 },
            { type = "item", name = "express-transport-belt", amount = 5 },
        },
        results = {
            {type="item", name="production-science-pack", amount=15},
            {type="item", name="logistic-science-pack", amount=15}
        },
        main_product="production-science-pack",
        allow_productivity = true
    },
    {
        type = "technology",
        name = "industrial-logistic-science",
        icon = "__base__/graphics/technology/production-science-pack.png",
        icon_size = 256,
        prerequisites = {"logistics-3"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="industrial-logistic-science"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "pumped-power-storage",
        icons = {
            {
                icon = "__base__/graphics/icons/accumulator.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fluid/water.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        energy_required = 40,
        allow_as_intermediate = false,
        allow_decomposition = false,
        auto_recycle=false,
        ingredients = {
            {type="item", name="pump", amount=1},
            {type="item", name="storage-tank", amount=1},
            {type="item", name="pipe", amount=20},
            {type="fluid", name="water", amount=200}
        },
        results = {
            {type="item", name="accumulator", amount=6}
        }
    },
    {
        type = "technology",
        name = "pumped-power-storage",
        icon = "__base__/graphics/technology/fluid-handling.png",
        icon_size = 256,
        prerequisites = {"fluid-handling"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="pumped-power-storage"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "solar-field",
        icons = {
            {
                icon = "__base__/graphics/icons/solar-panel.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/medium-electric-pole.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        energy_required = 45,
        allow_as_intermediate = false,
        allow_decomposition = false,
        auto_recycle=false,
        ingredients = {
            {type="item", name="efficiency-module", amount=1},
            {type="item", name="copper-cable", amount=50},
            {type="item", name="processing-unit", amount=1},
            {type="item", name="medium-electric-pole", amount=8}
        },
        results = {
            {type="item", name="solar-panel", amount=5}
        }
    },
    {
        type = "technology",
        name = "solar-field",
        icon = "__base__/graphics/technology/solar-energy.png",
        icon_size = 256,
        prerequisites = {"processing-unit"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="solar-field"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "bot-sacrifice",
        icons = {
            {
                icon = "__base__/graphics/icons/repair-pack.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/construction-robot.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "construction-robot", amount = 1 }
        },
        results = {
            {type="item", name="repair-pack", amount=10}
        }
    },
    {
        type = "technology",
        name = "the-needs-of-the-many",
        icon = "__base__/graphics/technology/repair-pack.png",
        icon_size = 256,
        prerequisites = {"construction-robotics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="bot-sacrifice"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "scientific-construction-robot",
        icons = {
            {
                icon = "__base__/graphics/icons/construction-robot.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/automation-science-pack.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 2,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "flying-robot-frame", amount = 1 },
            { type = "item", name = "automation-science-pack", amount = 1 }
        },
        results = {
            {type="item", name="construction-robot", amount=1}
        }
    },
    {
        type = "recipe",
        name = "scientific-logistic-robot",
        icons = {
            {
                icon = "__base__/graphics/icons/logistic-robot.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/logistic-science-pack.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 2,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "flying-robot-frame", amount = 1 },
            { type = "item", name = "logistic-science-pack", amount = 2 }
        },
        results = {
            {type="item", name="logistic-robot", amount=1}
        }
    },
    {
        type = "technology",
        name = "scientific-robots",
        icon = "__base__/graphics/technology/construction-robotics.png",
        icon_size = 256,
        prerequisites = {"construction-robotics", "logistic-robotics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="scientific-construction-robot"},
            {type = "unlock-recipe", recipe="scientific-logistic-robot"},
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "charged-furnace",
        icons = {
            {
                icon = "__base__/graphics/icons/electric-furnace.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/battery.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 3,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-plate", amount = 30 },
            { type = "item", name = "battery", amount = 10 },
            { type = "item", name = "refined-concrete", amount = 10 }
        },
        results = {
            {type="item", name="electric-furnace", amount=1}
        }
    },
    {
        type = "technology",
        name = "charged-furnace",
        icon = "__base__/graphics/technology/advanced-material-processing-2.png",
        icon_size = 256,
        prerequisites = {"battery"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="charged-furnace"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "microwave-furnace",
        icons = {
            {
                icon = "__base__/graphics/icons/electric-furnace.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/plastic-bar.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "plastic-bar", amount = 30 },
            { type = "item", name = "processing-unit", amount = 1 },
            { type = "item", name = "radar", amount = 5 }
        },
        results = {
            {type="item", name="electric-furnace", amount=2}
        }
    },
    {
        type = "technology",
        name = "microwave-furnace",
        icon = "__base__/graphics/technology/advanced-material-processing-2.png",
        icon_size = 256,
        prerequisites = {"processing-unit"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="microwave-furnace"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "hand-assembler",
        icons = {
            {
                icon = "__base__/graphics/icons/assembling-machine-2.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/fast-inserter.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 0.5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "steel-plate", amount = 3 },
            { type = "item", name = "fast-inserter", amount = 3 }
        },
        results = {
            {type="item", name="assembling-machine-2", amount=1}
        }
    },
    {
        type = "technology",
        name = "hand-assembler",
        icon = "__base__/graphics/technology/automation-2.png",
        icon_size = 256,
        prerequisites = {"fast-inserter"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="hand-assembler"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "linkage-inserter",
        icons = {
            {
                icon = "__base__/graphics/icons/inserter.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/iron-stick.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "electronic-circuit", amount = 1 },
            { type = "item", name = "iron-stick", amount = 5 }
        },
        results = {
            {type="item", name="inserter", amount=1}
        }
    },
    {
        type = "recipe",
        name = "long-linkage-inserter",
        icons = {
            {
                icon = "__base__/graphics/icons/long-handed-inserter.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/iron-stick.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "inserter", amount = 1 },
            { type = "item", name = "iron-stick", amount = 5 }
        },
        results = {
            {type="item", name="long-handed-inserter", amount=1}
        }
    },
    {
        type = "technology",
        name = "linkage-inserter",
        icon = "__base__/graphics/technology/fast-inserter.png",
        icon_size = 256,
        prerequisites = {"automation"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="linkage-inserter"},
            {type = "unlock-recipe", recipe="long-linkage-inserter"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "vehicle-correction",
        icons = {
            {
                icon = "__base__/graphics/icons/locomotive.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/repair-pack.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "car", amount = 2 },
            { type = "item", name = "repair-pack", amount = 25 }
        },
        results = {
            {type="item", name="locomotive", amount=1}
        }
    },
    {
        type = "recipe",
        name = "route-correction",
        icons = {
            {
                icon = "__base__/graphics/icons/rail.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/repair-pack.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "concrete", amount = 6 },
            { type = "item", name = "repair-pack", amount = 1 }
        },
        results = {
            {type="item", name="rail", amount=4}
        }
    },
    {
        type = "technology",
        name = "public-transportation",
        icon = "__base__/graphics/technology/railway.png",
        icon_size = 256,
        prerequisites = {"engine"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="vehicle-correction"},
            {type = "unlock-recipe", recipe="route-correction"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "pipe-bomb",
        icons = {
            {
                icon = "__base__/graphics/icons/grenade.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/pipe.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "pipe", amount = mods["BrassTacksMk2"] and 3 or 5 },
            { type = "item", name = "explosives", amount = 9 }
        },
        results = {
            {type="item", name="grenade", amount=1}
        }
    },
    {
        type = "technology",
        name = "pipe-bomb",
        icon = "__base__/graphics/technology/stronger-explosives-1.png",
        icon_size = 256,
        prerequisites = {"military-science-pack", "explosives"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="pipe-bomb"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "grenade-rocket-propellant",
        icons = {
            {
                icon = "__base__/graphics/icons/rocket-fuel.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/grenade.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting-with-fluid" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "grenade", amount = 1 },
            { type = "item", name = "explosives", amount = 2 },
            { type = "fluid", name = "light-oil", amount = 10 }
        },
        results = {
            {type="item", name="rocket-fuel", amount=1}
        }
    },
    {
        type = "technology",
        name = "grenade-propelled-rocket",
        icon = "__base__/graphics/technology/rocket-fuel.png",
        icon_size = 256,
        prerequisites = {"military-2"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="grenade-rocket-propellant"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "copper-magazine",
        icons = {
            {
                icon = "__base__/graphics/icons/firearm-magazine.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/copper-plate.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1.5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "copper-plate", amount = 4 }
        },
        results = {
            {type="item", name="firearm-magazine", amount=1}
        }
    },
    {
        type = "technology",
        name = "copper-magazine",
        icon = "__base__/graphics/technology/military.png",
        icon_size = 256,
        prerequisites = {"military"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="copper-magazine"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "shield-testing",
        icons = {
            {
                icon = "__base__/graphics/icons/military-science-pack.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/energy-shield-mk2-equipment.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 15,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "gun-turret", amount = 1 },
            { type = "item", name = "uranium-rounds-magazine", amount = 3 },
            { type = "item", name = "energy-shield-mk2-equipment", amount = 1, ignored_by_stats = 1 }
        },
        results = {
            { type = "item", name = "military-science-pack", amount = 3 },
            { type = "item", name = "utility-science-pack", amount = 1 },
            { type = "item", name = "energy-shield-mk2-equipment", amount = 1, independent_probability = .9, ignored_by_productivity = 1, ignored_by_stats = 1 }
        },
        allow_productivity = true,
        main_product = "military-science-pack"
    },
    {
        type = "technology",
        name = "shield-testing",
        icon = "__base__/graphics/technology/military-science-pack.png",
        icon_size = 256,
        prerequisites = {mods["space-age"] and "electromagnetic-science-pack" or "utility-science-pack", "military-science-pack"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="shield-testing"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "engine-transport-belt",
        icons = {
            {
                icon = "__base__/graphics/icons/fast-transport-belt.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/engine-unit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = mods["IfNickelMk2"] and 0.5 or 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "transport-belt", amount = mods["IfNickelMk2"] and 1 or 2 },
            { type = "item", name = "engine-unit", amount = 1 }
        },
        results = {
            {type="item", name="fast-transport-belt", amount=mods["IfNickelMk2"] and 1 or 2}
        }
    },
    {
        type = "recipe",
        name = "engine-underground-belt",
        icons = {
            {
                icon = "__base__/graphics/icons/fast-underground-belt.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/engine-unit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "underground-belt", amount = 2 },
            { type = "item", name = "engine-unit", amount = mods["IfNickelMk2"] and 4 or 8 }
        },
        results = {
            {type="item", name="fast-underground-belt", amount=2}
        }
    },
    {
        type = "recipe",
        name = "engine-splitter",
        icons = {
            {
                icon = "__base__/graphics/icons/fast-splitter.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/engine-unit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 0.5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "splitter", amount = 1 },
            { type = "item", name = "engine-unit", amount = mods["IfNickelMk2"] and 1 or 2 },
            { type = "item", name = "electronic-circuit", amount = 10 }
        },
        results = {
            {type="item", name="fast-splitter", amount=1}
        }
    },
    {
        type = "technology",
        name = "engine-transport-belt",
        icon = "__base__/graphics/technology/logistics-2.png",
        icon_size = 256,
        prerequisites = {"engine"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="engine-transport-belt"},
            {type = "unlock-recipe", recipe="engine-underground-belt"},
            {type = "unlock-recipe", recipe="engine-splitter"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "electric-engine-transport-belt",
        icons = {
            {
                icon = "__base__/graphics/icons/express-transport-belt.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/electric-engine-unit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 0.5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "fast-transport-belt", amount = 1 },
            { type = "item", name = "electric-engine-unit", amount = mods["IfNickelMk2"] and 1 or 2 }
        },
        results = {
            {type="item", name="express-transport-belt", amount=1}
        }
    },
    {
        type = "recipe",
        name = "electric-engine-underground-belt",
        icons = {
            {
                icon = "__base__/graphics/icons/express-underground-belt.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/electric-engine-unit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 0.5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "fast-underground-belt", amount = 2 },
            { type = "item", name = "electric-engine-unit", amount = mods["IfNickelMk2"] and 8 or 16 }
        },
        results = {
            {type="item", name="express-underground-belt", amount=2}
        }
    },
    {
        type = "recipe",
        name = "electric-engine-splitter",
        icons = {
            {
                icon = "__base__/graphics/icons/express-splitter.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/electric-engine-unit.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = mods["IfNickelMk2"] and 2 or 1,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "fast-splitter", amount = mods["IfNickelMk2"] and 2 or 1 },
            { type = "item", name = "electric-engine-unit", amount = 1 },
            { type = "item", name = "advanced-circuit", amount = mods["IfNickelMk2"] and 20 or 10 }
        },
        results = {
            {type="item", name="express-splitter", amount=mods["IfNickelMk2"] and 2 or 1}
        }
    },
    {
        type = "technology",
        name = "electric-engine-transport-belt",
        icon = "__base__/graphics/technology/logistics-3.png",
        icon_size = 256,
        prerequisites = {"electric-engine", "production-science-pack"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="electric-engine-transport-belt"},
            {type = "unlock-recipe", recipe="electric-engine-underground-belt"},
            {type = "unlock-recipe", recipe="electric-engine-splitter"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "rainbowport",
        icons = {
            {
                icon = "__base__/graphics/icons/roboport.png",
                icon_size = 64
            },
            {
                icon = "__AdequateAlternatives__/graphics/icons/rainbow.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 5,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "passive-provider-chest", amount = 1 },
            { type = "item", name = "active-provider-chest", amount = 1 },
            { type = "item", name = "requester-chest", amount = 1 },
            { type = "item", name = "buffer-chest", amount = 1 },
            { type = "item", name = "storage-chest", amount = 1 },
            { type = "item", name = "electric-engine-unit", amount = 15 },
        },
        results = {
            {type="item", name="roboport", amount=1}
        }
    },
    {
        type = "technology",
        name = "rainbowport",
        icon = "__base__/graphics/technology/logistic-robotics.png",
        icon_size = 256,
        prerequisites = {"logistic-system"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="rainbowport"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "low-density-stickture",
        icons = {
            {
                icon = "__base__/graphics/icons/low-density-structure.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/iron-stick.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "iron-stick", amount = 50 },
            { type = "item", name = "plastic-bar", amount = 10 },
            { type = "item", name = "copper-plate", amount = 10 },
        },
        results = {
            {type="item", name="low-density-structure", amount=1}
        }
    },
    {
        type = "technology",
        name = "low-density-stickture",
        icon = "__base__/graphics/technology/low-density-structure.png",
        icon_size = 256,
        prerequisites = {"plastics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="low-density-stickture"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "hippie-module",
        icons = {
            {
                icon = "__base__/graphics/icons/efficiency-module.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/wood.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 20,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "electronic-circuit", amount = 16 },
            { type = "item", name = "wood", amount = mods["BrimStuffMk2"] and 32 or 16 }
        },
        results = {
            {type="item", name="efficiency-module", amount=1}
        }
    },
    {
        type = "technology",
        name = "hippie-module",
        icon = "__base__/graphics/technology/efficiency-module-1.png",
        icon_size = 256,
        prerequisites = {"electronics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="hippie-module"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "coke-module",
        icons = {
            {
                icon = "__base__/graphics/icons/speed-module.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/solid-fuel.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "advanced-circuit", amount = 5 },
            { type = "item", name = "solid-fuel", amount = 5 }
        },
        results = {
            {type="item", name="speed-module", amount=1}
        }
    },
    {
        type = "technology",
        name = "coke-module",
        icon = "__base__/graphics/technology/speed-module-1.png",
        icon_size = 256,
        prerequisites = {"advanced-circuit"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="coke-module"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "mechanical-module",
        icons = {
            {
                icon = "__base__/graphics/icons/productivity-module.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/iron-gear-wheel.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 15,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "fast-inserter", amount = 2 },
            { type = "item", name = "flying-robot-frame", amount = 2 }
        },
        results = {
            {type="item", name="productivity-module", amount=1}
        }
    },
    {
        type = "technology",
        name = "mechanical-module",
        icon = "__base__/graphics/technology/productivity-module-1.png",
        icon_size = 256,
        prerequisites = {"electronics"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="mechanical-module"}
        },
        enabled = false
    },

    {
        type = "recipe",
        name = "production-module",
        icons = {
            {
                icon = "__base__/graphics/icons/productivity-module-2.png",
                icon_size = 64
            },
            {
                icon = "__base__/graphics/icons/production-science-pack.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 30,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "productivity-module", amount = 3 },
            { type = "item", name = "production-science-pack", amount = 3 },
            { type = "item", name = "repair-pack", amount = 5 }
        },
        results = {
            {type="item", name="productivity-module-2", amount=1}
        }
    },
    {
        type = "technology",
        name = "production-module",
        icon = "__base__/graphics/technology/productivity-module-2.png",
        icon_size = 256,
        prerequisites = {"production-science-pack"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="production-module"}
        },
        enabled = false
    },

    {
        type = "item",
        name = "module-casing",
        stack_size = 5,
        icon = "__AdequateAlternatives__/graphics/icons/module-casing.png",
        subgroup = "module",
        order = "0",
        icon_size = 64,
        inventory_move_sound = item_sounds.plastic_inventory_move,
        pick_sound = item_sounds.plastic_inventory_pickup,
        drop_sound = item_sounds.plastic_inventory_move,
        weight = 5*kg
    },
    {
        type = "recipe",
        name = "module-casing",
        categories = { "crafting" },
        enabled = false,
        energy_required = 3,
        ingredients = {
            { type = "item", name = "small-lamp", amount = 3 },
            { type = "item", name = "plastic-bar", amount = 5 }
        },
        results = {
            {type="item", name="module-casing", amount=1}
        },
        allow_productivity = true
    },
    {
        type = "recipe",
        name = "standardised-efficiency-module",
        icons = {
            {
                icon = "__base__/graphics/icons/efficiency-module.png",
                icon_size = 64
            },
            {
                icon = "__AdequateAlternatives__/graphics/icons/module-casing.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "advanced-circuit", amount = 4 },
            { type = "item", name = "module-casing", amount = 1 }
        },
        results = {
            {type="item", name="efficiency-module", amount=1}
        }
    },
    {
        type = "recipe",
        name = "standardised-speed-module",
        icons = {
            {
                icon = "__base__/graphics/icons/speed-module.png",
                icon_size = 64
            },
            {
                icon = "__AdequateAlternatives__/graphics/icons/module-casing.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "advanced-circuit", amount = 4 },
            { type = "item", name = "module-casing", amount = 1 }
        },
        results = {
            {type="item", name="speed-module", amount=1}
        }
    },
    {
        type = "recipe",
        name = "standardised-productivity-module",
        icons = {
            {
                icon = "__base__/graphics/icons/productivity-module.png",
                icon_size = 64
            },
            {
                icon = "__AdequateAlternatives__/graphics/icons/module-casing.png",
                icon_size = 64,
                scale = 0.25,
                shift = {8, -8}
            }
        },
        categories = { "crafting" },
        enabled = false,
        allow_as_intermediate = false,
        allow_decomposition = false,
        energy_required = 10,
        auto_recycle=false,
        ingredients = {
            { type = "item", name = "advanced-circuit", amount = 4 },
            { type = "item", name = "module-casing", amount = 1 }
        },
        results = {
            {type="item", name="productivity-module", amount=1}
        }
    },
    {
        type = "technology",
        name = "standardised-modules",
        icon = "__base__/graphics/technology/module.png",
        icon_size = 256,
        prerequisites = {"advanced-circuit"},
        unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
        effects = {
            {type = "unlock-recipe", recipe="module-casing"},
            {type = "unlock-recipe", recipe="standardised-efficiency-module"},
            {type = "unlock-recipe", recipe="standardised-speed-module"},
            {type = "unlock-recipe", recipe="standardised-productivity-module"},
        },
        enabled = false
    }
})

if mods["elevated-rails"] then

    data.raw["mod-data"]["adequate-alternatives-techs"].data["wooden-bridges"] = {name="wooden-bridges", weight=5, early=5, gleba=5, nauvis=5}

    data:extend({
        {
            type = "recipe",
            name = "wooden-rail-support",
            categories = { "advanced-crafting" },
            icons = {
                {
                    icon = "__elevated-rails__/graphics/icons/rail-support.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/wood.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            enabled = false,
            energy_required = 0.5,
            allow_as_intermediate = false,
            allow_decomposition = false,
            auto_recycle=false,
            ingredients = {
                {type="item", name="steel-plate", amount=10},
                {type="item", name="wood", amount=mods["BrimStuffMk2"] and 100 or 50}
            },
            results = {
                {type="item", name="rail-support", amount=1}
            }
        },
        {
            type = "recipe",
            name = "wooden-rail-ramp",
            categories = { "advanced-crafting" },
            icons = {
                {
                    icon = "__elevated-rails__/graphics/icons/rail-ramp.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/wood.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            enabled = false,
            energy_required = 0.5,
            allow_as_intermediate = false,
            allow_decomposition = false,
            auto_recycle=false,
            ingredients = {
                {type="item", name="steel-plate", amount=10},
                {type="item", name="rail", amount=8},
                {type="item", name="wood", amount=mods["BrimStuffMk2"] and 500 or 250}
            },
            results = {
                {type="item", name="rail-ramp", amount=1}
            }
        },
        {
            type = "technology",
            name = "wooden-bridges",
            icon = "__elevated-rails__/graphics/technology/elevated-rail.png",
            icon_size = 256,
            prerequisites = {"railway"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="wooden-rail-support"},
                {type = "unlock-recipe", recipe="wooden-rail-ramp"}
            },
            enabled = false
        },
    })
end

if not mods["space-age"] then
    data.raw["mod-data"]["adequate-alternatives-techs"].data["iron-leaching"] = {name="iron-leaching", weight=3, early=1}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["copper-leaching"] = {name="copper-leaching", weight=3, early=1}

    data:extend({
        {
            type = "recipe",
            name = "leached-iron-plate",
            icons = {
                {
                    icon = "__base__/graphics/icons/iron-plate.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "chemistry" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 16,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "iron-ore", amount = 8 },
                { type = "fluid", name = "sulfuric-acid", amount = 10 }
            },
            results = {
                {type="item", name="iron-plate", amount=10}
            },
            crafting_machine_tint = {
                primary = {0.5, 0.5, 1},
                secondary = {1, 1, 0.5},
                tertiary = {0.4, 0.2, 0},
                quaternary = {1, 1, 0}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "iron-leaching",
            icon = "__base__/graphics/technology/sulfur-processing.png",
            icon_size = 256,
            prerequisites = {"sulfur-processing"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="leached-iron-plate"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "leached-copper-plate",
            icons = {
                {
                    icon = "__base__/graphics/icons/copper-plate.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "chemistry" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 16,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "copper-ore", amount = 8 },
                { type = "fluid", name = "sulfuric-acid", amount = 10 }
            },
            results = {
                {type="item", name="copper-plate", amount=10}
            },
            crafting_machine_tint = {
                primary = {1, 0.62, 0.5},
                secondary = {1, 1, 0.5},
                tertiary = {0.4, 0.2, 0},
                quaternary = {1, 1, 0}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "copper-leaching",
            icon = "__base__/graphics/technology/sulfur-processing.png",
            icon_size = 256,
            prerequisites = {"sulfur-processing"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="leached-copper-plate"}
            },
            enabled = false
        }
    })
end

if mods["quality"] then
    data:extend({
        {
            type = "recipe",
            name = "standardised-quality-module",
            icons = {
                {
                    icon = "__quality__/graphics/icons/quality-module.png",
                    icon_size = 64
                },
                {
                    icon = "__AdequateAlternatives__/graphics/icons/module-casing.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "advanced-circuit", amount = 4 },
                { type = "item", name = "module-casing", amount = 1 }
            },
            results = {
                {type="item", name="quality-module", amount=1}
            }
        },

        {
            type = "recipe",
            name = "quantity-module",
            icons = {
                {
                    icon = "__quality__/graphics/icons/quality-module.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/arithmetic-combinator.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 5,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "arithmetic-combinator", amount = 3 },
                { type = "item", name = "plastic-bar", amount = 4 }
            },
            results = {
                {type="item", name="quality-module", amount=1}
            }
        },
        {
            type = "technology",
            name = "quantity-module",
            icon = "__quality__/graphics/technology/quality-module-1.png",
            icon_size = 256,
            prerequisites = {"plastics", "quality-module"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="quantity-module"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "uality-module",
            icons = {
                {
                    icon = "__quality__/graphics/icons/quality-module-2.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/utility-science-pack.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 30,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "quality-module", amount = 3 },
                { type = "item", name = "utility-science-pack", amount = 3 },
                { type = "item", name = "decider-combinator", amount = 2 }
            },
            results = {
                {type="item", name="quality-module-2", amount=1}
            }
        },
        {
            type = "technology",
            name = "uality-module",
            icon = "__quality__/graphics/technology/quality-module-2.png",
            icon_size = 256,
            prerequisites = {"utility-science-pack", "quality-module"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="uality-module"}
            },
            enabled = false
        }
    })

    tm.AddUnlock("standardised-modules", "standardised-quality-module")

    data.raw["mod-data"]["adequate-alternatives-techs"].data["quantity-module"] = {name="quantity-module", weight=5, early=5, nauvis=5, fulgora=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["uality-module"] = {name="uality-module", weight=5, late=2, fulgora=10}
end

if mods["space-age"] then
    rm.AddRecipeCategory("stone-circuit", "electromagnetics")
    rm.AddRecipeCategory("modern-circuit", "electromagnetics")
    rm.AddRecipeCategory("offsite-processor", "electromagnetics")

    rm.AddRecipeCategory("coked-steel", "metallurgy")
    tm.AddUnlock("steel-plate-productivity", {type="change-recipe-productivity", recipe="coked-steel", change=0.1, hidden=true})
    tm.AddUnlock("coked-steel", {type="nothing", icon="__AdequateAlternatives__/graphics/icons/productivity-up.png", icon_size = 64, effect_description = {"adequate-alternatives-still-gets-productivity", {"recipe-name.coked-steel"}, localised_technology_name("steel-plate-productivity")}})

    rm.AddRecipeCategory("fuel-polymerization", "cryogenics")
    tm.AddUnlock("plastic-bar-productivity", {type="change-recipe-productivity", recipe="fuel-polymerization", change=0.1, hidden=true})
    tm.AddUnlock("fuel-polymerization", {type="nothing", icon="__AdequateAlternatives__/graphics/icons/productivity-up.png", icon_size = 64, effect_description = {"adequate-alternatives-still-gets-productivity", {"recipe-name.fuel-polymerization"}, localised_technology_name("plastic-bar-productivity")}})

    rm.AddRecipeCategory("solar-field", "electromagnetics")

    rm.AddRecipeCategory("standardised-efficiency-module", "electromagnetics")
    rm.AddRecipeCategory("standardised-speed-module", "electromagnetics")
    rm.AddRecipeCategory("standardised-productivity-module", "electromagnetics")
    rm.AddRecipeCategory("standardised-quality-module", "electromagnetics")

    rm.AddRecipeCategory("hippie-module", "organic")
    rm.AddRecipeCategory("coke-module", "metallurgy")
    rm.AddRecipeCategory("mechanical-module", "cryogenics")
    rm.AddRecipeCategory("quantity-module", "electromagnetics")

    rm.AddRecipeCategory("production-module", "electromagnetics")
    rm.AddRecipeCategory("uality-module", "electromagnetics")

    rm.AddRecipeCategory("engine-transport-belt", "metallurgy")
    rm.AddRecipeCategory("engine-underground-belt", "metallurgy")
    rm.AddRecipeCategory("engine-splitter", "metallurgy")
    rm.AddRecipeCategory("electric-engine-transport-belt", "metallurgy")
    rm.AddRecipeCategory("electric-engine-underground-belt", "metallurgy")
    rm.AddRecipeCategory("electric-engine-splitter", "metallurgy")

    tm.AddUnlock("processing-unit-productivity", {type="change-recipe-productivity", recipe="difference-engine", change=0.1, hidden=true})
    tm.AddUnlock("difference-engine", {type="nothing", icon="__AdequateAlternatives__/graphics/icons/productivity-up.png", icon_size = 64, effect_description = {"adequate-alternatives-still-gets-productivity", {"recipe-name.difference-engine"}, localised_technology_name("processing-unit-productivity")}})

    tm.AddUnlock("low-density-structure-productivity", {type="change-recipe-productivity", recipe="low-density-stickture", change=0.1, hidden=true})
    tm.AddUnlock("low-density-stickture", {type="nothing", icon="__AdequateAlternatives__/graphics/icons/productivity-up.png", icon_size = 64, effect_description = {"adequate-alternatives-still-gets-productivity", {"recipe-name.low-density-stickture"}, localised_technology_name("low-density-structure-productivity")}})

    tm.AddUnlock("rocket-fuel-productivity", {type="change-recipe-productivity", recipe="grenade-rocket-propellant", change=0.1, hidden=true})
    tm.AddUnlock("grenade-propelled-rocket", {type="nothing", icon="__AdequateAlternatives__/graphics/icons/productivity-up.png", icon_size = 64, effect_description = {"adequate-alternatives-still-gets-productivity", {"recipe-name.grenade-rocket-propellant"}, localised_technology_name("rocket-fuel-productivity")}})

    tm.AddUnlock("scrap-recycling-productivity", {type="change-recipe-productivity", recipe="scrap-smelting", change=0.1, hidden=true})

    data.raw["mod-data"]["adequate-alternatives-techs"].data["express-module"] = {name="express-module", weight=5, late=5, gleba=5, vulcanus=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["energy-module"] = {name="energy-module", weight=5, late=5, gleba=5, fulgora=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["torture-engine"] = {name="torture-engine", weight=5, nauvis=10, gleba=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["yumako-battery"] = {name="yumako-battery", weight=5, gleba=10, fulgora=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["prompt-injection"] = {name="prompt-injection", weight=5, gleba=1, fulgora=10}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["exotic-asteroid-mining"] = {name="exotic-asteroid-mining", weight=10, late=5, nauvis=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["jelly-babies"] = {name="jelly-babies", weight=5, gleba=10}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["herbal-planning"] = { name = "herbal-planning", weight = 5, gleba=5, late=5 }
    data.raw["mod-data"]["adequate-alternatives-techs"].data["stone-melting"] = {name="stone-melting", weight=6, vulcanus=8}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["adequate-alternatives-fabricator"] = {name="adequate-alternatives-fabricator", weight=5, gleba=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["hydroponic-soil-substitute"] = {name="hydroponic-soil-substitute", weight=10, gleba=5, late=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["furndry"] = {name="furndry", weight=5, late=5, vulcanus=10}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["tungsten-magazine"] = {name="tungsten-magazine", weight=10, vulcanus=10, combat=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["holmium-smelting"] = {name="holmium-smelting", weight=2, vulcanus=2, fulgora=8}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["quantum-cryogenic-plant"] = {name="quantum-cryogenic-plant", weight=1, fulgora=3, late=3}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["lithium-energy-storage"] = {name="lithium-energy-storage", weight=5, fulgora=5, late=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["supermotor"] = {name="supermotor", weight=10, fulgora=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["dark-pink-circuit"] = {name="dark-pink-circuit", weight=10, fulgora=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["graphite-molds"] = {name="graphite-molds", weight=5, vulcanus=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["biosmelting"] = {name="biosmelting", weight=5, gleba=5, vulcanus=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["aerogel-foundation"] = {name="aerogel-foundation", weight=5, gleba=5}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["scrap-dredging"] = {name="scrap-dredging", weight=3, fulgora=5, gleba=2, late=3}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["scrap-smelting"] = {name="scrap-smelting", weight=1, fulgora=2, vulcanus=2, late=3}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["lava-electrolysis"] = {name="lava-electrolysis", weight=3, fulgora=5, vulcanus=5, late=3}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["gleba-reanimation"] = {name="gleba-reanimation", weight=5, gleba=5, fulgora=5, late=3}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["throughput-science-pack"] = {name="throughput-science-pack", weight=2, vulcanus=5, late=3}
    data.raw["mod-data"]["adequate-alternatives-techs"].data["fusion-science-pack"] = {name="fusion-science-pack", weight=2, fulgora=5, late=3}

    data:extend({
        {
            type = "recipe",
            name = "express-module",
            icons = {
                {
                    icon = "__base__/graphics/icons/speed-module-2.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/agricultural-science-pack.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 30,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "speed-module", amount = 3 },
                { type = "item", name = "agricultural-science-pack", amount = 1 },
                { type = "item", name = "express-transport-belt", amount = 3 }
            },
            results = {
                {type="item", name="speed-module-2", amount=1}
            }
        },
        {
            type = "technology",
            name = "express-module",
            icon = "__base__/graphics/technology/speed-module-2.png",
            icon_size = 256,
            prerequisites = {"agricultural-science-pack", "logistics-3"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="express-module"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "energy-module",
            icons = {
                {
                    icon = "__base__/graphics/icons/efficiency-module-2.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/electromagnetic-science-pack.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 30,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "efficiency-module", amount = 3 },
                { type = "item", name = "electromagnetic-science-pack", amount = 1 },
                { type = "item", name = "big-electric-pole", amount = 2 }
            },
            results = {
                {type="item", name="efficiency-module-2", amount=1}
            }
        },
        {
            type = "technology",
            name = "energy-module",
            icon = "__base__/graphics/technology/efficiency-module-2.png",
            icon_size = 256,
            prerequisites = {"electromagnetic-science-pack"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="energy-module"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "torture-engine",
            icons = {
                {
                    icon = "__base__/graphics/icons/engine-unit.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/biter-egg.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "advanced-crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 5,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "biter-egg", amount = 1 },
                { type = "item", name = "fast-transport-belt", amount = mods["IfNickelMk2"] and 2 or 1 },
            },
            results = {
                {type="item", name="engine-unit", amount=1}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "torture-engine",
            icon = "__base__/graphics/technology/engine.png",
            icon_size = 256,
            prerequisites = {"captivity"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="torture-engine"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "yumako-battery",
            icons = {
                {
                    icon = "__base__/graphics/icons/battery.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/yumako.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "organic" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 1,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "yumako", amount = 1 },
                { type = "item", name = "iron-stick", amount = 2 },
                { type = "item", name = "copper-cable", amount = 2 },
            },
            results = {
                {type="item", name="battery", amount=1}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "yumako-battery",
            icon = "__base__/graphics/technology/battery.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-gleba"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="yumako-battery"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "supermotor",
            icons = {
                {
                    icon = "__base__/graphics/icons/electric-engine-unit.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/superconductor.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting-with-fluid" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 4,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "iron-gear-wheel", amount = mods["IfNickelMk2"] and 5 or 3 },
                { type = "item", name = "superconductor", amount = 3 },
                { type = "fluid", name = "lubricant", amount = 20 },
            },
            results = {
                {type="item", name="electric-engine-unit", amount=1}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "supermotor",
            icon = "__base__/graphics/technology/electric-engine.png",
            icon_size = 256,
            prerequisites = {"electromagnetic-plant"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="supermotor"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "dark-pink-circuit",
            icons = {
                {
                    icon = "__base__/graphics/icons/advanced-circuit.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/superconductor.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 8,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "electronic-circuit", amount = 3 },
                { type = "item", name = "superconductor", amount = 1 },
                { type = "item", name = "holmium-plate", amount = 1 },
            },
            results = {
                {type="item", name="advanced-circuit", amount=2}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "dark-pink-circuit",
            icon = "__base__/graphics/technology/advanced-circuit.png",
            icon_size = 256,
            prerequisites = {"electromagnetic-plant"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="dark-pink-circuit"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "ignore-all-previous-instructions",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/spoilage.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/processing-unit.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 20,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "processing-unit", amount = 1 },
            },
            results = {
                {type="item", name="spoilage", amount=1000}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "prompt-injection",
            icon = "__base__/graphics/technology/processing-unit.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-gleba"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="ignore-all-previous-instructions"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "jelly-baby",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/pentapod-egg.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/jelly.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "organic" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 20,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "jelly", amount = 200 },
            },
            results = {
                {type="item", name="pentapod-egg", amount=1}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "jelly-babies",
            icon = "__space-age__/graphics/technology/biochamber.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-gleba"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="jelly-baby"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "stone-melting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/fluid/lava.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/stone.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "vulcanus-processes",
            order = "0",
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 16,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "stone", amount = 50 },
                { type = "item", name = "calcite", amount = 1 },
            },
            results = {
                {type="fluid", name="lava", amount=250}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "stone-melting",
            icon = "__space-age__/graphics/technology/foundry.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-vulcanus"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="stone-melting"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "adequate-alternatives-fabricator", --"fabricator" is very generic, not taking chances on collisions
            icons = {
                {
                    icon = "__base__/graphics/icons/assembling-machine-3.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/carbon-fiber.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 16,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "electric-engine-unit", amount = 3 },
                { type = "item", name = "carbon-fiber", amount = 50 },
            },
            results = {
                {type="item", name="assembling-machine-3", amount=1}
            }
        },
        {
            type = "technology",
            name = "adequate-alternatives-fabricator",
            icon = "__base__/graphics/technology/automation-3.png",
            icon_size = 256,
            prerequisites = {"carbon-fiber"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="adequate-alternatives-fabricator"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "furndry",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/foundry.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/electric-furnace.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "electric-furnace", amount = 3 },
                { type = "item", name = "steel-furnace", amount = 5 },
                { type = "item", name = "express-transport-belt", amount = 5 },
                { type = "item", name = "tungsten-plate", amount = 25 },
            },
            results = {
                {type="item", name="foundry", amount=1}
            }
        },
        {
            type = "technology",
            name = "furndry",
            icon = "__space-age__/graphics/technology/foundry.png",
            icon_size = 256,
            prerequisites = {"foundry", "production-science-pack"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="furndry"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "tungsten-magazine",
            icons = {
                {
                    icon = "__base__/graphics/icons/uranium-rounds-magazine.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/tungsten-ore.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 8,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "firearm-magazine", amount = 2 },
                { type = "item", name = "tungsten-plate", amount = 1 }
            },
            results = {
                {type="item", name="uranium-rounds-magazine", amount=1}
            }
        },
        {
            type = "technology",
            name = "tungsten-magazine",
            icon = "__base__/graphics/technology/uranium-ammo.png",
            icon_size = 256,
            prerequisites = {"tungsten-steel", "uranium-ammo"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="tungsten-magazine"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "holmium-smelting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/holmium-plate.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/stone-furnace.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "smelting", "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 6.4,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "holmium-ore", amount = 1 },
            },
            results = {
                {type="item", name="holmium-plate", amount=2}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "holmium-smelting",
            icon = "__space-age__/graphics/technology/holmium-processing.png",
            icon_size = 256,
            prerequisites = {"holmium-processing"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="holmium-smelting"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "scrap-dredging",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/scrap.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/fluid/heavy-oil.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting-with-fluid" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 25,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "carbon-fiber", amount = 10 },
                { type = "item", name = "agricultural-science-pack", amount = 1 },
                { type = "fluid", name = "heavy-oil", amount = 1000 },
            },
            results = {
                {type="item", name="scrap", amount=50}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "scrap-dredging",
            icon = "__recycler__/graphics/technology/recycling.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-fulgora", "agricultural-science-pack"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="scrap-dredging"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "lava-electrolysis",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/tungsten-ore.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/fluid/lava.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 25,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "calcite", amount = 1 },
                { type = "item", name = "electromagnetic-science-pack", amount = 1 },
                { type = "fluid", name = "lava", amount = 1000 },
            },
            results = {
                {type="item", name="tungsten-ore", amount=20}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "lava-electrolysis",
            icon = "__space-age__/graphics/technology/foundry.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-vulcanus", "electromagnetic-science-pack"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="lava-electrolysis"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "scrap-smelting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/fluid/molten-iron.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/scrap.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "fulgora-processes",
            order = "a[trash]-a[trash-recycling]-smelting",
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 25,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "calcite", amount = 1 },
                { type = "item", name = "metallurgic-science-pack", amount = 1 },
                { type = "item", name = "scrap", amount = 25 },
            },
            results = {
                { type = "item", name = "holmium-ore", amount = 1 },
                { type = "fluid", name = "molten-iron", amount = 250 },
                { type = "fluid", name = "molten-copper", amount = 150 }
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "scrap-smelting",
            icon = "__space-age__/graphics/technology/foundry.png",
            icon_size = 256,
            prerequisites = {"electromagnetic-science-pack", "metallurgic-science-pack"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                { type = "unlock-recipe", recipe = "scrap-smelting" },
                {type="nothing", icon="__AdequateAlternatives__/graphics/icons/productivity-up.png", icon_size = 64, effect_description = {"adequate-alternatives-still-gets-productivity", {"recipe-name.scrap-smelting"}, localised_technology_name("scrap-recycling-productivity")}}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "gleba-reanimation",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/yumako.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/superconductor.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "agriculture-products",
            order = "dc",
            categories = { "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 25,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "superconductor", amount = 1 },
                { type = "item", name = "electromagnetic-science-pack", amount = 1 },
                { type = "item", name = "spoilage", amount = 100 },
            },
            results = {
                { type = "item", name = "yumako", amount = 10, quality_max=mods["quality"] and "uncommon" or nil },
                { type = "item", name = "jellynut", amount = 5, quality_max=mods["quality"] and "uncommon" or nil },
                { type = "item", name = "pentapod-egg", amount = 1, independent_probability=0.01, quality_max=mods["quality"] and "uncommon" or nil },
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "gleba-reanimation",
            icon = "__space-age__/graphics/technology/lightning-collector.png",
            icon_size = 256,
            prerequisites = {"electromagnetic-science-pack", "planet-discovery-gleba"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="gleba-reanimation"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "iron-biosmelting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/fluid/molten-iron.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/iron-bacteria.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "vulcanus-processes",
            order="a[melting]-b[iron-ore-melting]-bio",
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 16,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "iron-bacteria", amount = 10 },
                { type = "item", name = "carbon", amount = 1 },
            },
            results = {
                { type = "item", name = "spoilage", amount = 2 },
                { type = "fluid", name = "molten-iron", amount = 100 }
            },
            allow_productivity = true
        },
        {
            type = "recipe",
            name = "copper-biosmelting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/fluid/molten-copper.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/copper-bacteria.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "vulcanus-processes",
            order="a[melting]-c[copper-ore-melting]-bio",
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 16,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "copper-bacteria", amount = 10 },
                { type = "item", name = "carbon", amount = 1 },
            },
            results = {
                { type = "item", name = "spoilage", amount = 2 },
                { type = "fluid", name = "molten-copper", amount = 100 }
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "biosmelting",
            icon = "__space-age__/graphics/technology/bacteria-cultivation.png",
            icon_size = 256,
            prerequisites = {"foundry", "planet-discovery-gleba"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="iron-biosmelting"},
                {type = "unlock-recipe", recipe="copper-biosmelting"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "aerogel-foundation",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/space-platform-foundation.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/jelly.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 30,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "low-density-structure", amount = 1 },
                { type = "item", name = "jelly", amount = 50 },
                { type = "item", name = "plastic-bar", amount = 10 },
            },
            results = {
                {type="item", name="space-platform-foundation", amount=2}
            }
        },
        {
            type = "technology",
            name = "aerogel-foundation",
            icon = "__space-age__/graphics/technology/space-platform.png",
            icon_size = 256,
            prerequisites = {"biochamber"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="aerogel-foundation"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "quantum-cryogenic-plant",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/cryogenic-plant.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/quantum-processor.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "cryogenics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "oil-refinery", amount = 2 },
                { type = "item", name = "quantum-processor", amount = 10 },
                { type = "item", name = "supercapacitor", amount = 10 },
                { type = "fluid", name = "fluoroketone-cold", amount = 100 },
            },
            results = {
                {type="item", name="cryogenic-plant", amount=1}
            },
            surface_conditions = {
                {property="pressure", max=600}
            }
        },
        {
            type = "technology",
            name = "quantum-cryogenic-plant",
            icon = "__space-age__/graphics/technology/cryogenic-plant.png",
            icon_size = 256,
            prerequisites = {"quantum-processor"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="quantum-cryogenic-plant"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "lithium-accumulator",
            icons = {
                {
                    icon = "__base__/graphics/icons/accumulator.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/lithium-plate.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "lithium-plate", amount = 1 },
                { type = "item", name = "copper-plate", amount = 5 },
                { type = "item", name = "supercapacitor", amount = 1 },
                { type = "fluid", name = "fluoroketone-cold", amount = 2 }
            },
            results = {
                { type = "item", name = "accumulator", amount = 1 },
                { type = "fluid", name = "fluoroketone-hot", amount = 1, ignored_by_productivity = 1 }
            },
            main_product = "accumulator"
        },
        {
            type = "recipe",
            name = "lithium-supercapacitor",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/supercapacitor.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/lithium-plate.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "electromagnetics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 25,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "lithium-plate", amount = 1 },
                { type = "item", name = "processing-unit", amount = 1 },
                { type = "item", name = "superconductor", amount = 10 },
                { type = "fluid", name = "electrolyte", amount = 75 }
            },
            results = {
                {type="item", name="supercapacitor", amount=5}
            },
            allow_productivity = true,
        },
        {
            type = "technology",
            name = "lithium-energy-storage",
            icon = "__base__/graphics/technology/electric-energy-acumulators.png",
            icon_size = 256,
            prerequisites = {"cryogenic-plant"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="lithium-accumulator"},
                {type = "unlock-recipe", recipe="lithium-supercapacitor"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "asteroid-uranium-sorting",
            icons = {
                {
                    icon = "__base__/graphics/icons/uranium-ore.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/metallic-asteroid-chunk.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "centrifuging" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 3,
            surface_conditions = {{property="gravity", min=0, max=0}},
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "metallic-asteroid-chunk", amount = 1 },
                { type = "item", name = "carbonic-asteroid-chunk", amount = 1 },
                { type = "item", name = "oxide-asteroid-chunk", amount = 1 },
            },
            results = {
                {type="item", name="uranium-ore", amount=1}
            },
            allow_productivity = true
        },
        {
            type = "recipe",
            name = "promethium-uranium-sorting",
            icons = {
                {
                    icon = "__base__/graphics/icons/uranium-ore.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/promethium-asteroid-chunk.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "centrifuging" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 1,
            surface_conditions = {{property="gravity", min=0, max=0}},
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "promethium-asteroid-chunk", amount = 1 }
            },
            results = {
                {type="item", name="uranium-ore", amount=1}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "exotic-asteroid-mining",
            icon = "__base__/graphics/technology/uranium-mining.png",
            icon_size = 256,
            prerequisites = {"rocket-silo", "uranium-mining"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="asteroid-uranium-sorting"},
                {type = "unlock-recipe", recipe="promethium-uranium-sorting"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "traffic-jam",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/jelly.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/rail-signal.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "agriculture-products",
            order = "da",
            categories = { "organic" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 5,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "jelly", amount = 20 },
                { type = "fluid", name = "light-oil", amount = 5 }
            },
            results = {
                {type="item", name="rail-signal", amount=1},
                {type="item", name="stone-brick", amount=1},
                {type="item", name="car", amount=1, independent_probability=0.01},
            }
        },
        {
            type = "recipe",
            name = "fruitput",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/yumako-mash.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/fast-transport-belt.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "agriculture-products",
            order = "db",
            categories = { "organic" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 5,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "yumako-mash", amount = 20 },
                { type = "fluid", name = "heavy-oil", amount = 5 }
            },
            results = {
                {type="item", name="fast-transport-belt", amount=1},
                {type="item", name="pipe", amount=1},
                {type="item", name="express-transport-belt", amount=1, independent_probability=0.01},
            }
        },
        {
            type = "technology",
            name = "herbal-planning",
            icon = "__space-age__/graphics/technology/agriculture.png",
            icon_size = 256,
            prerequisites = {"planet-discovery-gleba", "recycling"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="traffic-jam"},
                {type = "unlock-recipe", recipe="fruitput"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "hydroponic-yumako-soil",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/artificial-yumako-soil.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/low-density-structure.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "organic" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "yumako-seed", amount = 1 },
                { type = "item", name = "low-density-structure", amount = 10 },
                { type = "item", name = "pipe", amount = 100 },
            },
            results = {
                {type="item", name="artificial-yumako-soil", amount=10}
            },
            allow_productivity = true
        },
        {
            type = "recipe",
            name = "hydroponic-jellynut-soil",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/artificial-jellynut-soil.png",
                    icon_size = 64
                },
                {
                    icon = "__base__/graphics/icons/low-density-structure.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "crafting", "organic" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "jellynut-seed", amount = 1 },
                { type = "item", name = "low-density-structure", amount = 10 },
                { type = "item", name = "pipe", amount = 100 },
            },
            results = {
                {type="item", name="artificial-jellynut-soil", amount=10}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "hydroponic-soil-substitute",
            icon = "__space-age__/graphics/technology/artificial-soil.png",
            icon_size = 256,
            prerequisites = {"agriculture"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="hydroponic-yumako-soil"},
                {type = "unlock-recipe", recipe="hydroponic-jellynut-soil"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "graphite-copper-casting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/fluid/molten-copper.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/carbon.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "vulcanus-processes",
            order = "b[casting]-b[casting-copper]-graphite",
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "fluid", name = "molten-copper", amount = 100 },
                { type = "item", name = "carbon", amount = 1 }
            },
            results = {
                {type="item", name="copper-plate", amount=12}
            },
            allow_productivity = true
        },
        {
            type = "recipe",
            name = "graphite-iron-casting",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/fluid/molten-iron.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/carbon.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            subgroup = "vulcanus-processes",
            order = "b[casting]-a[casting-iron]-graphite",
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 10,
            auto_recycle=false,
            ingredients = {
                { type = "fluid", name = "molten-iron", amount = 100 },
                { type = "item", name = "carbon", amount = 1 }
            },
            results = {
                {type="item", name="iron-plate", amount=12}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "graphite-molds",
            icon = "__space-age__/graphics/technology/foundry.png",
            icon_size = 256,
            prerequisites = {"foundry"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="graphite-iron-casting"},
                {type = "unlock-recipe", recipe="graphite-copper-casting"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "throughput-science-pack",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/metallurgic-science-pack.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/turbo-transport-belt.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "metallurgy" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 200,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "turbo-transport-belt", amount = 10 },
                { type = "item", name = "cliff-explosives", amount = 1 },
                { type = "item", name = "foundry", amount = 1 },
            },
            surface_conditions = {
              {property = "pressure", min=4000, max=4000}
            },
            results = {
                {type="item", name="metallurgic-science-pack", amount=16}
            },
            allow_productivity = true
        },
        {
            type = "technology",
            name = "throughput-science-pack",
            icon = "__space-age__/graphics/technology/metallurgic-science-pack.png",
            icon_size = 256,
            prerequisites = {"turbo-transport-belt"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="throughput-science-pack"}
            },
            enabled = false
        },

        {
            type = "recipe",
            name = "fusion-science-pack",
            icons = {
                {
                    icon = "__space-age__/graphics/icons/cryogenic-science-pack.png",
                    icon_size = 64
                },
                {
                    icon = "__space-age__/graphics/icons/quantum-processor.png",
                    icon_size = 64,
                    scale = 0.25,
                    shift = {8, -8}
                }
            },
            categories = { "cryogenics" },
            enabled = false,
            allow_as_intermediate = false,
            allow_decomposition = false,
            energy_required = 60,
            auto_recycle=false,
            ingredients = {
                { type = "item", name = "quantum-processor", amount = 1 },
                { type = "item", name = "fusion-power-cell", amount = 1 },
                { type = "fluid", name = "fluoroketone-cold", amount = 20 },
            },
            surface_conditions = {
              {property = "pressure", min=300, max=600}
            },
            results = {
                {type="item", name="cryogenic-science-pack", amount=3},
                {type="item", name="electromagnetic-science-pack", amount=1},
                {type="fluid", name="fluoroketone-hot", amount=10, ignored_by_productivity = 10}
            },
            main_product = "cryogenic-science-pack",
            allow_productivity = true
        },
        {
            type = "technology",
            name = "fusion-science-pack",
            icon = "__space-age__/graphics/technology/cryogenic-science-pack.png",
            icon_size = 256,
            prerequisites = {"fusion-reactor"},
            unit = {time = 1, count = 1, ingredients = {{"dummy-tech-point", 1}}},
            effects = {
                {type = "unlock-recipe", recipe="fusion-science-pack"}
            },
            enabled = false
        },
    })
end
