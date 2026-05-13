#using scripts\codescripts\struct;

function init()
{
    level thread xp_ui_main();
}

function xp_ui_main()
{
    level endon("end_game");

    for (;;)
    {
        level waittill("connected", player);

        if (!isdefined(player))
            continue;

        player thread xp_ui_player_loop();
    }
}

function xp_ui_player_loop()
{
    self endon("disconnect");

    wait 0.2; // IMPORTANT: let clientuimodel exist

    self.xp_bar_smooth = 0;
    self.last_level = 1;

    for (;;)
    {
        wait 0.05;

        if (!isdefined(self.clientuimodel))
            continue;

        xp_ui_update_bar(self);
        xp_ui_update_level_text(self);
        xp_ui_check_level_up(self);
    }
}

function get_xp(player)
{
    if (!isdefined(player.clientuimodel["xp.current"]))
        return 0;

    return player.clientuimodel["xp.current"];
}

function get_level(player)
{
    if (!isdefined(player.clientuimodel["xp.level"]))
        return 1;

    return player.clientuimodel["xp.level"];
}

function get_needed(player)
{
    if (!isdefined(player.clientuimodel["xp.needed"]))
        return 100;

    return player.clientuimodel["xp.needed"];
}

function xp_ui_update_bar(player)
{
    xp = get_xp(player);
    needed = get_needed(player);

    if (needed <= 0)
        needed = 100;

    progress = xp / needed;

    if (progress > 1) progress = 1;
    if (progress < 0) progress = 0;

    player.xp_bar_smooth += (progress - player.xp_bar_smooth) * 0.12;

    player.clientuimodel["xp.bar"] = player.xp_bar_smooth;
}

function xp_ui_update_level_text(player)
{
    player.clientuimodel["xp.level_text"] = get_level(player);
}

function xp_ui_check_level_up(player)
{
    lvl = get_level(player);

    if (!isdefined(player.last_level))
        player.last_level = lvl;

    if (lvl > player.last_level)
    {
        player.last_level = lvl;
        player thread xp_ui_level_up_fx();
    }
}

function xp_ui_level_up_fx()
{
    self iprintlnbold("LEVEL UP!");

    if (!isdefined(self.clientuimodel["xp.lvlup"]))
        self.clientuimodel["xp.lvlup"] = 0;

    self.clientuimodel["xp.lvlup"]++;
}
