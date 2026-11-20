for k, v in pairs(data.raw.lab) do
    if v.science_pack_drain_rate_percent == 100 or not v.science_pack_drain_rate_percent then
        table.insert(v.inputs, "biter-nest-data")
        if mods["space-age"] then
            table.insert(v.inputs, "demolisher-data")
            table.insert(v.inputs, "precursor-data")
            table.insert(v.inputs, "pentapod-data")
        end
    end
end
