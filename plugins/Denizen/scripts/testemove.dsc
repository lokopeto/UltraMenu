selecionarmenu:
    type: world
    events:
        on player join:
            - flag player menu:1
            - flag player menulimite:3
            - flag player teleport:!

            - adjust player gamemode:adventure

#            - invisible <player> true

            - run menufade1
            - repeat 50:
                - wait 1t
                - teleport <player> <location[-21.8303,174.3267,113.5369,-90,112.5466,world]>
            - inject fakeentity
#            - flag player teleport

#            - cast LEVITATION <player> duration:0 amplifier:255 hide_particles no_icon no_ambient

        on player quits:
            - remove <server.npcs_flagged[menuinicionpc.<player>]>
            - remove <server.npcs_flagged[startmenu.<player>]>

        on player walks:
            - if <player.flag[teleport].exists>:

                - narrate "<context.old_location.z> <context.new_location.z>"

                - if <context.old_location.z> < <context.new_location.z>:
                    - if <player.flag[menu]> > 1:
                        - if <player.flag[menu]> = 3:
                            - define dois segundomenu
                        - flag player menu:-:1
                        - define reverse _reverse
                    - else:
                        - determine cancelled

                    - narrate <player.flag[menu]>

                - if <context.old_location.z> > <context.new_location.z>:
                    - if <player.flag[menu]> < <player.flag[menulimite]>:
                        - if <player.flag[menu]> = 1:
                            - define dois inicio
                        - flag player menu:+:1
                        - define reverse ""
                    - else:
                        - determine cancelled

                    - narrate <player.flag[menu]>

                - if <player.flag[menu]> = 1:
                    - run anim_inicio<[reverse]>

                - if <player.flag[menu]> = 2:
                    - run anim_<[dois]><[reverse]>


                - if <player.flag[menu]> = 3:
                    - run anim_segundomenu<[reverse]>


                - determine cancelled

#        on player clicks block:
#            - if <player.flag[menu]> = 2:
#                - run fakeentity_start_click
#                - wait 2s
#                - run menufade2


menufade1:
    debug: false
    type: task
    script:
        - title title:<black><&chr[0100].font[filter:default]> fade_in:0s fade_out:3s

menufade2:
    debug: false
    type: task
    script:
        - title title:<black><&chr[0100].font[filter:default]> fade_in:3s stay:2s


fakeentity:
    type: task
    script:
        - create player <player.name> <location[-25.5,175.00,114.5,0,180,world]> save:fakeplayer1

        - adjust <entry[fakeplayer1].created_npc> hide_from_players
        - adjust <player> show_entity:<entry[fakeplayer1].created_npc>
        - flag <entry[fakeplayer1].created_npc> menuinicionpc.<player>

        - create boat startmenu_<player.name> <location[-24.41,175.00,110.53,-40.5,0,world]> traits:meg_model save:startmenu

        - invisible <entry[startmenu].created_npc> true for:<server.players>
        - invisible <entry[startmenu].created_npc> false for:<player>
        - flag <entry[startmenu].created_npc> startmenu.<player>

        - wait 5t

        - execute as_server "npc sit --id <entry[fakeplayer1].created_npc.id>" silent

        - execute as_server "meg npc model citizens:<entry[startmenu].created_npc.id> add passarin" silent

fakeentity_start_click:
    type: task
    script:
        - execute as_server "npc stand --id <server.npcs_flagged[menuinicionpc.<player>].get[1].id>" silent
        - wait 10t
        - walk <server.npcs_flagged[menuinicionpc.<player>].get[1]> <location[-15.5,168.00,101.5,0,0,world]> auto_range

fakeentity_start_select:
    type: task
    script: