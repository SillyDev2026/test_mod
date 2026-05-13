function init()
{
    iprintln("XP SYSTEM ONLINE");
}

function init_player_xp(player)
{
    if (!isdefined(player))
        return;

    player.xp = 0;
    player.xp_level = 1;
    player.xp_needed = 100;

    player.clientuimodel["xp.current"] = 0;
    player.clientuimodel["xp.level"]   = 1;
    player.clientuimodel["xp.needed"]  = 100;
    player.clientuimodel["xp.lvlup"]   = 0;
    iprintln("xp: " + player.xp + " xp_level: " + player.xp_level + " xp_needed: " + player.xp_needed);
}

function add_xp(player, amount)
{
    if (!isdefined(player))
        return;

    if (!isdefined(player.clientuimodel))
        return;

    if (!isdefined(player.xp))
    {
        player.xp = 0;
        player.xp_level = 1;
        player.xp_needed = 100;
    }

    player.xp += amount;

    player iprintln("XP +" + amount);

    // 🔥 ALWAYS SYNC TO CLIENTUIMODEL (CORRECT KEYS)
    player.clientuimodel["xp.current"] = player.xp;
    player.clientuimodel["xp.level"]   = player.xp_level;
    player.clientuimodel["xp.needed"]  = player.xp_needed;

    while (player.xp >= player.xp_needed)
    {
        player.xp -= player.xp_needed;
        player.xp_level++;
        player.xp_needed = int(100 * (player.xp_level ^ 1.35));

        // 🔥 SYNC AGAIN AFTER LEVEL UP
        player.clientuimodel["xp.current"] = player.xp;
        player.clientuimodel["xp.level"]   = player.xp_level;
        player.clientuimodel["xp.needed"]  = player.xp_needed;

        // level up trigger
        player.clientuimodel["xp.lvlup"]++;

        player notify("xp_level_up");
    }
    player.clientuimodel["xp.current"] = player.xp;
    player.clientuimodel["xp.level"]   = player.xp_level;
    player.clientuimodel["xp.needed"]  = player.xp_needed;
}

function get_xp_from_hit(hit_location, mod)
{
    switch (hit_location)
    {
        case "head":
        case "helmet":
            return 15;

        case "neck":
        case "torso_upper":
            return 10;

        case "torso_lower":
            return 5;

        default:
            return 3;
    }
}

function on_kill(player, hit_location, mod)
{
    if (!isdefined(player))
        return;

    xp = get_xp_from_hit(hit_location, mod);
    add_xp(player, xp);
}
