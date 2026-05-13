#using scripts\zm\xp_system;

function init()
{
    iprintln("MAIN ACTIVE");

    level thread onGameStart();
    level thread playerMonitor();
}

function onGameStart()
{
    level endon("game_ended");

    level waittill("start_of_round");

    iprintln("ROUND STARTED");
}

function playerMonitor()
{
    level endon("game_ended");

    for (;;)
    {
        level waittill("connected", player);

        if (!isdefined(player))
            continue;

        player thread player_init_flow();
    }
}

function player_init_flow()
{
    self endon("disconnect");

    self waittill("spawned");

    xp_system::init_player_xp(self);

    self thread player_spawn_loop();
}

function player_spawn_loop()
{
    self endon("disconnect");

    iprintln("PLAYER SPAWNED");
}
