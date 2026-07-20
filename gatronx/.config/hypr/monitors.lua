--Monitor Principal
hl.monitor({
	output   = "DP-1",
	mode     = "1920x1080@164.92Hz",
	position = "0x0",
	scale    = 1,
})
hl.workspace_rule({
	workspace = 1,
	monitor = "DP-1",
})


--Monitor 2
--hl.monitor({
--    output   = "HDMI-A-2",
--    mode     = "1680x1050@59.95",
--    position = "1920x0",
--    scale    = 1,
--})
--hl.workspace_rule({
--    workspace = 2,
--    monitor = "HDMI-A-2",
--})

