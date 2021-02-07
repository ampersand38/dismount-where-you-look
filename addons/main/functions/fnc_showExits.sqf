#include "script_component.hpp"
/*
Author: Ampers
PFH to show which exit the player is looking at

* Arguments:
* None
*
* Return Value:
* None

* Example:
* [] call dwyl_main_fnc_showExits
*/

if !(isNull curatorCamera) exitWith {};

private _vehicle = vehicle player;
if (_vehicle == player) exitWith {};

private _sp = [_vehicle] call dwyl_main_fnc_getExits;

dwyl_exit_position = nil;

dwyl_main_colour = ["IGUI", "TEXT_RGB"] call BIS_fnc_displayColorGet;
dwyl_main_colour_faded = [
    dwyl_main_colour select 0,
    dwyl_main_colour select 1,
    dwyl_main_colour select 2,
    (dwyl_main_colour select 3) / 2
];

dwyl_exit_pfh_running = true;
dwyl_exit_position = nil;
[{
    params ["_args", "_pfID"];
    _args params ["_vehicle", "_sp"];
    dwyl_exit_memoryPoint = nil;
    if (!dwyl_exit_pfh_running || {vehicle player == player}) exitWith {
        [_pfID] call CBA_fnc_removePerFrameHandler;
    };
    if (vehicle player == player) exitWith {
        dwyl_exit_pfh_running = false;
        [_pfID] call CBA_fnc_removePerFrameHandler;
    };

    private _indexClosest = [_vehicle, _sp] call dwyl_main_fnc_findLookedAt;
    dwyl_exit_position = _sp select _indexClosest;

    {
        private _isSelected = _forEachIndex == _indexClosest;
        private _colour = [dwyl_main_colour_faded, dwyl_main_colour] select _isSelected;
        private _size = [ICON_SIZE_NOTSELECTED, ICON_SIZE_SELECTED] select _isSelected;
        drawIcon3D ["a3\ui_f\data\IGUI\Cfg\Actions\getout_ca.paa", _colour, _vehicle modelToWorldVisual _x, _size, _size, 0, ""];
    } forEach _sp;
}, 0, [_vehicle, _sp]] call CBA_fnc_addPerFrameHandler;
