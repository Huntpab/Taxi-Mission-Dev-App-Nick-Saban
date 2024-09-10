_myPlayer = player;

_actionID = _myPlayer addAction ["Call Taxi", {
    params ["_target", "_caller", "_actionID"];

    _caller removeAction _actionID;

    hint "Taxi is on its way!";

    _myPlayerPos = getPos _caller;

    _heli = taxi;

    _heli allowDamage false;
    _heli setDamage 0;

    {
        _x allowDamage false;
        _x setDamage 0;
    } forEach crew _heli;

    _distance = _heli distance _myPlayerPos;

    _velocity = velocity _heli;
    _speed = sqrt ((_velocity select 0)^2 + (_velocity select 1)^2 + (_velocity select 2)^2);

    if (_speed <= 0) then {
        _speed = 100;
    };

    _eta = _distance / _speed;

    _eta = _eta + 75;

    _minutes = floor(_eta / 60);
    _seconds = _eta - (_minutes * 60);

    hint format [
        "Player's Position: X: %1, Y: %2, Z: %3\nDistance: %4 meters\nAdjusted ETA: %5 min %6 sec",
        _myPlayerPos select 0,
        _myPlayerPos select 1,
        _myPlayerPos select 2,
        round _distance,
        _minutes,
        round _seconds
    ];

    _heliGroup = group _heli;

    _wp1 = _heliGroup addWaypoint [_myPlayerPos, 0];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointSpeed "FULL";
    _wp1 setWaypointCompletionRadius 20;

    _wp2 = _heliGroup addWaypoint [_myPlayerPos, 0];
    _wp2 setWaypointType "SCRIPTED";
    _wp2 setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";

    hint format [
        "Helicopter is en route to your position! ETA: %1 min %2 sec",
        _minutes,
        round _seconds
    ];

    sleep 20;

    while {!isTouchingGround _heli} do {
        sleep 0.1;
    };
    hint "Helicopter has landed! You have 20 seconds to enter the taxi before it leaves.";

    sleep 20;

    _nearestGarage = [14698.4, 16725.4, 0];

    _wp1 = _heliGroup addWaypoint [_nearestGarage, 0];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointSpeed "FULL";
    _wp1 setWaypointCompletionRadius 20;

    _wp2 = _heliGroup addWaypoint [_nearestGarage, 0];
    _wp2 setWaypointType "SCRIPTED";
    _wp2 setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";

    hint "Taxi will proceed to nearest garage.";

    sleep 20;

    while {!isTouchingGround _heli} do {
        sleep 0.1;
    };
    hint "Helicopter has landed! You have 5 seconds to exit the taxi.";

    sleep 5;

    _heli lock 2;

    if (vehicle _caller == _heli) then {
        _caller action ["getOut", _heli];
        hint "You have been dropped off at the nearest garage.";
    };

    sleep 2;

    _away = [1000, 20000, 0];

    _wp1 = _heliGroup addWaypoint [_away, 0];
    _wp1 setWaypointType "MOVE";
    _wp1 setWaypointSpeed "FULL";
    _wp1 setWaypointCompletionRadius 20;

    _wp2 = _heliGroup addWaypoint [_away, 0];
    _wp2 setWaypointType "SCRIPTED";
    _wp2 setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";

}];
