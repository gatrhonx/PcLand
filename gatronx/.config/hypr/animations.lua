-- Curvas de animación
hl.curve("easeOutExpo",  { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
hl.curve("easeInExpo",   { type = "bezier", points = { {0.7, 0}, {0.84, 0} } })
hl.curve("snappy",       { type = "bezier", points = { {0.1, 0.9}, {0.2, 1} } })


-- Workspaces (cambio de escritorio)
hl.animation({ leaf = "workspaces",    enabled = true, speed = 2.2, bezier = "snappy", style = "slidefade 15%" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 2.2, bezier = "snappy", style = "slidefade 15%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.8, bezier = "snappy", style = "slidefade 15%" })

-- Ventanas (abrir/cerrar/mover)
hl.animation({ leaf = "windows",     enabled = true, speed = 2.5, bezier = "snappy",   style = "popin 85%" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 2.5, bezier = "easeOutExpo", style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 1.8, bezier = "easeInExpo",  style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3,   bezier = "snappy" })

-- Bordes y fade general
hl.animation({ leaf = "border", enabled = true, speed = 3,   bezier = "snappy" })
hl.animation({ leaf = "fade",   enabled = true, speed = 2.5, bezier = "snappy" })


-- Layers (wofi)
hl.animation({ leaf = "layersIn",  enabled = true, speed = 3,   bezier = "easeOutExpo", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.2, bezier = "easeInExpo",  style = "popin 70%" })

-- Layer rule para wofi
hl.layer_rule({
    match = { namespace = "wofi" },
    blur = true,
    ignore_alpha = 0.5,
})
