My own GMod Lua script that includes:
- ESP: displays username, distance from you, health, and armor above targets (color key: red is admin, green is regular user)
- Tracers: draws a line from the center of the screen to target's head
- Aimbot: aims your cursor at the closest visible target, uses the distance formula: sqrt(relativeX^2 + relativeY^2), the relative x,y,z coordinates, and the ArcTan2 function to calculate the angle
- Triggerbot: shoots when your cursor contacts a target
- Bhop: auto jumps when the jump key is held down

Each function is toggled on or off by using the command line in game (meaning you can bind keys to their commands)

Generates 0 Lua errors!