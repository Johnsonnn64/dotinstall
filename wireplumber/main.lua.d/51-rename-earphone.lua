rule = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_06_00.6.HiFi__hw_Generic_1__sink"},
    },
  },
  apply_properties = {
    ["node.description"] = "Earphones",
  },
}

table.insert(alsa_monitor.rules,rule)
