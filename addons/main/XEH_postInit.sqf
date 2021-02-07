#include "script_component.hpp"

if (!hasInterface) exitWith {};

[
    "Dismount Where You Look", "dwyl_dismount", "Dismount",
    dwyl_main_fnc_exit,
    {},
    [48, [false, true, false]], false                  //, 0, true
] call CBA_fnc_addKeybind; // V

[
    "Dismount Where You Look", "dwyl_main_showExits", "Show Exits (Hold)",
    dwyl_main_fnc_showExits,
    {
        [{dwyl_exit_pfh_running = false;}] call CBA_fnc_execNextFrame;
    }, [0, [false, false, false]], false                  //, 0, true
] call CBA_fnc_addKeybind; // Unbound

[
    "Dismount Where You Look", "dwyl_main_showAndDismount", "Show Exits And Dismount On Release",
    dwyl_main_fnc_showExits,
    dwyl_main_fnc_exit,
    [0, [false, false, false]], false                  //, 0, true
] call CBA_fnc_addKeybind; // Unbound
