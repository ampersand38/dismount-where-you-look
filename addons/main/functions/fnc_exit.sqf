#include "script_component.hpp"
/*
Author: Ampers
Player exits vehicle at the chosen memory point.

* Arguments:
* None
*
* Return Value:
* None

* Example:
* [] call dwyl_main_fnc_exit
*/

if dwyl_exit_pfh_running then {dwyl_exit_pfh_running = false};
private _vehicle = vehicle player;
if (_vehicle == player) exitWith {};

if (isNil "dwyl_exit_position") then {
    private _sp = [_vehicle] call dwyl_main_fnc_getExits;
    private _indexClosest = [_vehicle, _sp] call dwyl_main_fnc_findLookedAt;
    dwyl_exit_position = _sp select _indexClosest;
};

if (_vehicle != player) then {
    moveOut player;
};

[{
    player == vehicle player
}, {
    player attachTo [_this, dwyl_exit_position vectorAdd [0, 0, -1]];
    dwyl_exit_position set [2, 0];
    player setVectorDirAndUp [
        dwyl_exit_position,
        [0, 0, 1]
    ];
    [{
        dwyl_exit_position = nil;
        detach player
    }] call CBA_fnc_execNextFrame;
}, _vehicle, 1] call CBA_fnc_waitUntilAndExecute;
