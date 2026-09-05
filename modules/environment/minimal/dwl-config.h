#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const int sloppyfocus               = 1;
static const int bypass_surface_visibility = 0;
static const unsigned int borderpx         = 1;
static const float rootcolor[]             = COLOR(0x111111ff);
static const float bordercolor[]           = COLOR(0x333333ff);
static const float focuscolor[]            = COLOR(0xe0e0e0ff);
static const float urgentcolor[]           = COLOR(0xffffff00);
static const float fullscreen_bg[]         = {0.0f, 0.0f, 0.0f, 1.0f};

/* 10 тегов как 10 воркспейсов в Hyprland */
#define TAGCOUNT (10)

static int log_level = WLR_ERROR;

static const Rule rules[] = {
	{ "foot",             NULL,       0,            0,           -1 },
	{ "fuzzel",           NULL,       0,            1,           -1 },
	{ "pavucontrol",      NULL,       0,            1,           -1 },
	{ "nm-connection-editor", NULL,   0,            1,           -1 },
};

static const Layout layouts[] = {
	{ "[]=",      tile },
	{ "><>",      NULL },
	{ "[M]",      monocle },
};

static const MonitorRule monrules[] = {
	{ NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
};

/* keyboard layout: us,ru с переключением по Alt+Shift (как в Hyprland) */
static const struct xkb_rule_names xkb_rules = {
	.rules = NULL,
	.model = NULL,
	.layout = "us,ru",
	.variant = NULL,
	.options = "grp:alt_shift_toggle,grp_led:caps",
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

#define MODKEY WLR_MODIFIER_LOGO

/* 10 тегов = 10 воркспейсов */
#define TAGKEYS(KEY,SKEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/*
 * ── Приложения ────────────────────────────────────────────────
 */
static const char *termcmd[]  = { "foot", NULL };                                  /* Super+A */
static const char *filecmd[]  = { "foot", "-e", "yazi", NULL };                    /* Super+E файлменеджер (в терминале) */
static const char *menucmd[]  = { "fuzzel", NULL };                                /* Super+R */
static const char *browscmd[] = { "zen-browser", NULL };                           /* Super+W */
static const char *lockcmd[]  = { "swaylock", "-c", "111111", NULL };              /* Super+L / Super+X */
static const char *sessioncmd[] = { "swaylock", "-c", "111111", NULL };            /* Super+X */
static const char *cliphistcmd[] = { "/bin/sh", "-c",
                                     "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy",
                                     NULL };                                        /* Super+V */

static const Key keys[] = {
	/* ── WINDOW MANAGEMENT ─────────────────────────────── */
	{ MODKEY,                    XKB_KEY_q,           killclient,       {0} },         /* Super+Q     закрыть окно */
	{ MODKEY,                    XKB_KEY_f,           togglefullscreen, {0} },         /* Super+F     во весь экран */
	{ MODKEY,                    XKB_KEY_space,       togglefloating,   {0} },         /* Super+Space плавающее окно */
	{ MODKEY,                    XKB_KEY_j,           focusstack,       {.i = +1} },   /* рядом с окнами */
	{ MODKEY,                    XKB_KEY_k,           focusstack,       {.i = -1} },   /* (фокус вместо стрелок) */

	/* ── LAUNCHER / APPS ────────────────────────────────── */
	{ MODKEY,                    XKB_KEY_a,           spawn,            {.v = termcmd} },  /* Super+A терминал */
	{ MODKEY,                    XKB_KEY_e,           spawn,            {.v = filecmd} },  /* Super+E файлменеджер */
	{ MODKEY,                    XKB_KEY_r,           spawn,            {.v = menucmd} },  /* Super+R лаунчер */
	{ MODKEY,                    XKB_KEY_w,           spawn,            {.v = browscmd} }, /* Super+W браузер */

	/* ── UTILITIES ──────────────────────────────────────── */
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_s,           spawn,            SHCMD("grim -g \"$(slurp)\" - | wl-copy") }, /* Super+Shift+S скриншот */
	{ MODKEY,                    XKB_KEY_v,           spawn,            {.v = cliphistcmd} }, /* Super+V буфер обмена */
	{ MODKEY,                    XKB_KEY_x,           spawn,            {.v = sessioncmd} }, /* Super+X меню сессии */
	{ MODKEY,                    XKB_KEY_l,           spawn,            {.v = lockcmd} },  /* Super+L lock */

	/* ── MEDIA / VOLUME / BRIGHTNESS ────────────────────── */
	{ 0,                         XKB_KEY_XF86AudioRaiseVolume,  spawn, SHCMD("pamixer -i 5") },
	{ 0,                         XKB_KEY_XF86AudioLowerVolume,  spawn, SHCMD("pamixer -d 5") },
	{ 0,                         XKB_KEY_XF86AudioMute,         spawn, SHCMD("pamixer -t") },
	{ 0,                         XKB_KEY_XF86MonBrightnessUp,   spawn, SHCMD("brightnessctl set +5%") },
	{ 0,                         XKB_KEY_XF86MonBrightnessDown, spawn, SHCMD("brightnessctl set 5%-") },
	{ 0,                         XKB_KEY_XF86AudioPlay,         spawn, SHCMD("playerctl play-pause") },
	{ 0,                         XKB_KEY_XF86AudioNext,         spawn, SHCMD("playerctl next") },
	{ 0,                         XKB_KEY_XF86AudioPrev,         spawn, SHCMD("playerctl previous") },

	/* ── WORKSPACES (10 тегов) ──────────────────────────── */
	TAGKEYS(          XKB_KEY_1, XKB_KEY_exclam,                        0),
	TAGKEYS(          XKB_KEY_2, XKB_KEY_at,                            1),
	TAGKEYS(          XKB_KEY_3, XKB_KEY_numbersign,                    2),
	TAGKEYS(          XKB_KEY_4, XKB_KEY_dollar,                        3),
	TAGKEYS(          XKB_KEY_5, XKB_KEY_percent,                       4),
	TAGKEYS(          XKB_KEY_6, XKB_KEY_asciicircum,                   5),
	TAGKEYS(          XKB_KEY_7, XKB_KEY_ampersand,                     6),
	TAGKEYS(          XKB_KEY_8, XKB_KEY_asterisk,                      7),
	TAGKEYS(          XKB_KEY_9, XKB_KEY_parenleft,                     8),
	TAGKEYS(          XKB_KEY_0, XKB_KEY_parenright,                    9),

	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_Terminate_Server, quit, {0} },
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
