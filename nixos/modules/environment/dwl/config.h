/* appearance - Cachy colors from Hyprland */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }

static const int sloppyfocus               = 1;
static const int bypass_surface_visibility = 0;
static const unsigned int borderpx         = 2;
static const float rootcolor[]             = COLOR(0x0e0e0eff);
static const float bordercolor[]           = COLOR(0x131313ff);
static const float focuscolor[]            = COLOR(0xb3c5ffff);
static const float urgentcolor[]           = COLOR(0xffb4abff);
static const float fullscreen_bg[]         = {0.0f, 0.0f, 0.0f, 1.0f};

/* gaps (vanitygaps patch) */
static const int smartgaps                 = 0;
static const unsigned int gappih           = 3;
static const unsigned int gappiv           = 3;
static const unsigned int gappoh           = 8;
static const unsigned int gappov           = 8;
static const int monoclegaps               = 0;

/* tagging */
#define TAGCOUNT (9)

/* logging */
static int log_level = WLR_ERROR;

static const Rule rules[] = {
  /* app_id        title       tags mask     isfloating   monitor */
  { NULL,         NULL,       0,            0,           -1 },
};

/* layout(s) - only master (tile) */
static const Layout layouts[] = {
  { "[]=",      tile },
};

/* monitors */
static const MonitorRule monrules[] = {
  { NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
  .options = NULL,
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
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

#define TAGKEYS(KEY,SKEY,TAG) \
  { MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
  { MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
  { MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }, \
  { MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* autostart (autostart patch) - from Hyprland autostart.lua */
static const char *const autostart[] = {
  "dbus-update-activation-environment", "--systemd", "--all", NULL,
  "noctalia", NULL,
  "xhost", "+SI:localuser:root", NULL,
  NULL
};

/* commands */
static const char *termcmd[] = { "foot", NULL };
static const char *browsercmd[] = { "zen-beta", NULL };
static const char *fmcmd[] = { "nautilus", NULL };

static const Key keys[] = {
  /* launches */
  { MODKEY,                    XKB_KEY_a,           spawn,            {.v = termcmd} },
  { MODKEY,                    XKB_KEY_w,           spawn,            {.v = browsercmd} },
  { MODKEY,                    XKB_KEY_e,           spawn,            {.v = fmcmd} },

  /* window management */
  { MODKEY,                    XKB_KEY_q,           killclient,       {0} },
  { MODKEY,                    XKB_KEY_f,           togglefullscreen, {0} },
  { MODKEY,                    XKB_KEY_space,       togglefloating,   {0} },

  /* focus */
  { MODKEY,                    XKB_KEY_Left,        focusstack,       {.i = -1} },
  { MODKEY,                    XKB_KEY_Right,       focusstack,       {.i = +1} },

  /* move windows (movestack patch) */
  { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Left,        movestack,        {.i = -1} },
  { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Right,       movestack,        {.i = +1} },

  /* master area control */
  { MODKEY,                    XKB_KEY_h,           setmfact,         {.f = -0.05f} },
  { MODKEY,                    XKB_KEY_l,           setmfact,         {.f = +0.05f} },
  { MODKEY,                    XKB_KEY_i,           incnmaster,       {.i = +1} },
  { MODKEY,                    XKB_KEY_d,           incnmaster,       {.i = -1} },

  /* tags */
  { MODKEY,                    XKB_KEY_Tab,         view,             {0} },
  { MODKEY,                    XKB_KEY_0,           view,             {.ui = ~0} },
  { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_parenright,  tag,              {.ui = ~0} },
  TAGKEYS(          XKB_KEY_1, XKB_KEY_exclam,                        0),
  TAGKEYS(          XKB_KEY_2, XKB_KEY_at,                            1),
  TAGKEYS(          XKB_KEY_3, XKB_KEY_numbersign,                    2),
  TAGKEYS(          XKB_KEY_4, XKB_KEY_dollar,                        3),
  TAGKEYS(          XKB_KEY_5, XKB_KEY_percent,                       4),
  TAGKEYS(          XKB_KEY_6, XKB_KEY_asciicircum,                   5),
  TAGKEYS(          XKB_KEY_7, XKB_KEY_ampersand,                     6),
  TAGKEYS(          XKB_KEY_8, XKB_KEY_asterisk,                      7),
  TAGKEYS(          XKB_KEY_9, XKB_KEY_parenleft,                     8),

  /* Noctalia IPC */
  { MODKEY,                    XKB_KEY_r,           spawn,            SHCMD("noctalia msg panel-toggle launcher") },
  { MODKEY,                    XKB_KEY_s,           spawn,            SHCMD("noctalia msg panel-toggle control-center") },
  { MODKEY,                    XKB_KEY_comma,       spawn,            SHCMD("noctalia msg settings-toggle") },
  { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_S,          spawn,            SHCMD("noctalia msg screenshot-region") },
  { MODKEY,                    XKB_KEY_v,           spawn,            SHCMD("noctalia msg panel-toggle clipboard") },
  { MODKEY,                    XKB_KEY_x,           spawn,            SHCMD("noctalia msg panel-toggle session") },
  { MODKEY,                    XKB_KEY_l,           spawn,            SHCMD("noctalia msg session lock") },
  { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_R,          spawn,            SHCMD("noctalia quit; sleep 0.3; noctalia") },
  { MODKEY,                    XKB_KEY_t,           spawn,            SHCMD("noctalia msg wallpaper-random") },

  /* media / volume / brightness */
  { 0,                         XKB_KEY_XF86AudioRaiseVolume,  spawn,  SHCMD("noctalia msg volume-up") },
  { 0,                         XKB_KEY_XF86AudioLowerVolume,  spawn,  SHCMD("noctalia msg volume-down") },
  { 0,                         XKB_KEY_XF86AudioMute,         spawn,  SHCMD("noctalia msg volume-mute") },
  { 0,                         XKB_KEY_XF86MonBrightnessUp,   spawn,  SHCMD("noctalia msg brightness-up") },
  { 0,                         XKB_KEY_XF86MonBrightnessDown, spawn,  SHCMD("noctalia msg brightness-down") },
  { 0,                         XKB_KEY_XF86AudioPlay,         spawn,  SHCMD("noctalia msg media toggle") },
  { 0,                         XKB_KEY_XF86AudioNext,         spawn,  SHCMD("noctalia msg media next") },
  { 0,                         XKB_KEY_XF86AudioPrev,         spawn,  SHCMD("noctalia msg media previous") },

  /* quit */
  { MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT, XKB_KEY_q, quit, {0} },
  { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_Terminate_Server, quit, {0} },

/* Ctrl-Alt-Fx VT switch */
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
  CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
  CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
  { MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
  { MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
