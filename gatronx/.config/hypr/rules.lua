

-- Window rules wallpaper-selector
hl.window_rule({
    match = { class = "python3", title = "wallpaper-selector" },
    float = true,
    center = true,
    opacity = "0.92 0.92"
})

hl.window_rule({
    match = { class = "firefox", title = "^Picture-in-Picture$" },
    float = true,
    pin   = true,
    size  = "480 270",
    keep_aspect_ratio = true,
    move  = "70% 5%",
})
