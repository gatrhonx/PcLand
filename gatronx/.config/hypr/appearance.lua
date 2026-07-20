hl.config({
    misc = {
--	vfr = true,                     -- variable frame rate
	vrr = 1,                        -- variable refresh rate
	disable_hyprland_logo = true,
	disable_splash_rendering = true,
	force_default_wallpaper = 0,
	background_color = 0x000000,
	},

    general = {
	resize_on_border = false,       -- resize windows
	no_focus_fallback = false,
        gaps_in = 6,
        gaps_out = 10,
        border_size = 2,
        layout = "dwindle",
    },

    decoration = {
        rounding = 8,
        active_opacity = 1.0,
        inactive_opacity = 0.8,
        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            new_optimizations = true,
        },
    },

})






