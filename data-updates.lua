local tm = require("__pf-functions__/technology-manipulation")

tm.AddUnlock("military-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
tm.AddUnlock("military-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

tm.AddUnlock("chemical-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
tm.AddUnlock("chemical-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

tm.AddUnlock("production-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
tm.AddUnlock("production-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

tm.AddUnlock("utility-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
tm.AddUnlock("utility-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

tm.AddUnlock("space-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
tm.AddUnlock("space-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

if mods["space-age"] then
    tm.AddUnlock("metallurgic-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
    tm.AddUnlock("metallurgic-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

    tm.AddUnlock("electromagnetic-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
    tm.AddUnlock("electromagnetic-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

    tm.AddUnlock("agricultural-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
    tm.AddUnlock("agricultural-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

    tm.AddUnlock("cryogenic-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
    tm.AddUnlock("cryogenic-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

    tm.AddUnlock("promethium-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/tech-point.png", effect_description={"adequate-alternatives-tech-reward-upgrade-point"}})
    tm.AddUnlock("promethium-science-pack", {type = "nothing", icon_size=64, icon="__AdequateAlternatives__/graphics/icons/new-options.png", effect_description={"adequate-alternatives-tech-reward-options"}})

    table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "gene-vault", amount_min = 2, amount_max = 5 })
    table.insert(data.raw["simple-entity"]["small-demolisher-corpse"].minable.results, 1, { type = "item", name = "worm-guts", amount = 1 })
    table.insert(data.raw["simple-entity"]["medium-demolisher-corpse"].minable.results, 1, { type = "item", name = "worm-guts", amount = 1 })
    table.insert(data.raw["simple-entity"]["big-demolisher-corpse"].minable.results, 1,
        { type = "item", name = "worm-guts", amount_min = 1, amount_max = 2 })

    data.raw["simple-entity"]["fulgoran-ruin-vault"].loot = {{ type = "item", name = "gene-vault", amount_min = 2, amount_max = 5 }}
    data.raw["simple-entity"]["small-demolisher-corpse"].loot = {{ type = "item", name = "worm-guts", amount = 1 }}
    data.raw["simple-entity"]["medium-demolisher-corpse"].loot = {{ type = "item", name = "worm-guts", amount = 1 }}
    data.raw["simple-entity"]["big-demolisher-corpse"].loot = {{ type = "item", name = "worm-guts", amount_min = 1, amount_max = 2 }}
end
