# tween.nut
Based on original project [tween.lua](https://love2d.org/wiki/tween.lua).
tween.nut is a small library to perform tweening in Squirell. It has a minimal interface, and it comes with several easing functions.


# Examples: 
NOTE: For get all easing functions you must check `tween.nut` file. All functions placed in `Tween.easing(Tween["easing"])`Example how works linear, outInCubic and outInBounce UI animations:

![alt text](https://gitlab.com/g2o/scripts/gui-framework/uploads/daf18bbd14264b3d65958917d7ca3fcc/linear.gif)
![alt text](https://gitlab.com/g2o/scripts/gui-framework/uploads/5ab40189ec28d1d44c0b16a7bd20a148/outInCubic.gif)
![alt text](https://gitlab.com/g2o/scripts/gui-framework/uploads/dc49f4c721cf5d299bfbdd98c355d90a/outInBounce.gif)

Example code (based on bar.nut from [GUI Framework](https://gitlab.com/g2o/scripts/gui-framework.git) example:
```c
// ... bar.nut example code

local barPosition = {x = 0, y = getResolution().y - 50};
// We create tween for 4 sec duration, barPosition like subject, his target values and interpolation method
local uiAni = Tween(4, barPosition, {x = getResolution().x - 200, y = getResolution().y - 50}, Tween.easing.linear);

// Called, when tween animation was done
addEventHandler ("Tween.onEnded", function (tween) {
	// Restore animation, for play it again
	if (tween == uiAni) {
		 barPosition = {x = 0, y = getResolution().y - 50};
		 uiAni = Tween(4, barPosition, {x = getResolution().x - 200, y = getResolution().y - 50}, Tween.easing.linear);
	}
});

// Set our bar position on 'barPosition'
addEventHandler ("onRender", function () {
	horizontalBar.setPositionPx(barPosition.x, barPosition.y);
});
```

# Tween creation
```c
local tween = Tween(duration, subject, target, easing)
```

Creates a new tween.
- `duration` means how much the change will take until it's finished. It must be a positive number.
- `subject` must be a table with at least one key-value. Its values will be gradually changed by the tween until they look like `target`. All the values must be numbers, or tables with numbers.
- `target` must be a table with at least the same keys as `subject`. Other keys will be ignored.
- `easing` can be either a function (see also `Tween.["easing"]` table).
- `tween` is the object that must be used to perform the changes.

When tween was complete for doing changes, he call `Tween.onEnded(Tween)` event (also check Examples)

# Tween methods
```c
local complete = t.set(clock)
```

Moves a tween's internal clock to a particular moment.

- `t` is a tween returned by class constructor
- `clock` is a positive number or 0. It's the new value of the tween's internal clock.
- `complete` works like in `Tween.update`; it's true if the tween has reached its end, and false otherwise.
If `clock` is greater than `t.duration`, then the values in `t.subject` will be equal to `t.target`, and `t.clock` will be equal to `t.duration`.

```c
t.reset()
```
Resets the internal `clock` of the tween back to 0, resetting subject.

- `t` is a tween returned by class constructor
This method is equivalent to `t.set(0)`.

# Easing functions
Easing functions are functions that express how slow/fast the interpolation happens in tween.

`tween.nut` comes with 45 default easing functions already built-in (adapted from [Emmanuel Oga's easing library](https://github.com/EmmanuelOga/easing)).

![alt text](https://camo.githubusercontent.com/d1bd2ce0cebbf0a007994e329c0a5485b0947d29b698d303ac7eb951c0ef7a81/68747470733a2f2f6b696b69746f2e6769746875622e696f2f747765656e2e6c75612f696d672f747765656e2d66616d696c6965732e706e67)

# Credits

The easing functions have been copied from EmmanuelOga's project in

https://github.com/emmanueloga/easing

Original `tween.lua` project

https://github.com/kikito/tween.lua.git
