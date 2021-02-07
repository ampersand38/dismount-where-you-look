#include "script_component.hpp"
/*
Author: Ampers
Return mirrored and filtered positions of get in memory points

* Arguments:
* 0: Vehicle <OBJECT>
*
* Return Value:
* 0: Positions relative to vehicle <ARRAY>
    [
        [x, y, z],
        [x, y, z],
        ...
    ]

* Example:
* [vehicle player] call dwyl_main_fnc_getExits
*/

params ["_vehicle"];

// get proxies
private _sn = _vehicle selectionNames "Memory" select {
    _x select [0,4] == "pos " && {_x find "dir" == -1}
};
if (_sn isEqualTo []) exitWith {};

private _sp = _sn apply {_vehicle selectionPosition _x vectorAdd [0, 0, 1]};
_sn append (_sn apply {"M" + _x});

// Mirror exits
private _mirror = _sp apply {[_x # 0 * -1, _x # 1, _x # 2]};
_sp append _mirror;

// Filter exits
private _spNormalized = _sp apply {vectorNormalized _x};
private _redundantIndices = [];
private _redundantIndexGroups = [];

{
    private _currSp = _x;
    private _currIndex = _forEachIndex;
    {
        // Check each pair of points to see if they are too close
        if (_currIndex != _forEachIndex && {
            _currSp vectorDotProduct _x > 0.98
        }) then {
            _redundantIndices pushBackUnique _currIndex;
            _redundantIndices pushBackUnique _forEachIndex;
            private _pairIndex = _forEachIndex;
            private _doesPairHaveKnownElement = false;
            {
                if (_x find _currIndex > -1 || {
                    _x find _pairIndex > -1
                }) exitWith {
                    _x pushBackUnique _currIndex;
                    _x pushBackUnique _pairIndex;
                    _doesPairHaveKnownElement = true;
                };
            } forEach _redundantIndexGroups;

            if !_doesPairHaveKnownElement then {
                private _group = [_currIndex, _forEachIndex];
                _group sort true;
                _redundantIndexGroups pushBackUnique _group;
            }
        };
    } forEach _spNormalized;
} forEach _spNormalized;

if (count _redundantIndices > 1) then {
    _redundantIndices sort false;
};

private _groupSPs = [];
{
    private _vector = [0,0,0];
    {
        _vector = _vector vectorAdd (_sp # _x);
    } forEach _x;
    _groupSPs pushBack (_vector vectorMultiply (1 / count _x));
} forEach _redundantIndexGroups;

{
    _sp deleteAt _x;
} forEach _redundantIndices;

_sp append _groupSPs;

_sp
