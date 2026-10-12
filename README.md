# Parking Spot Spawner

A Cyberpunk 2077 mod that lets you mark your own parking spots anywhere in the world and keep your owned vehicles on them. A spot is the word PARKING painted on the ground. Walk up to it to bring one of your vehicles out onto the spot, or to put the vehicle away again.

- The vehicles are the game's own. They are brought out through the game's vehicle call, so they count as yours to the game and to other mods.
- Each spot remembers its vehicle. Place as many spots as you like and have a different vehicle out on each at the same time.
- A vehicle stays where it stands until you put it away, however far you travel.
- Spots are saved with the game.

## Placing a spot

1. Press `F6`. A green post follows your crosshair along the ground, up to 30 metres away. Aim it where the word should go.
2. Press `F6` again to set it down. The vehicle's outline appears on the far side of the post, with its nose marked in red. Line it up with the keys below.
3. Press `F6` a third time to save the spot. The word is painted where the post stood, reading upright as you look across it at the vehicle's place.

| Key | While placing |
|---|---|
| `,` and `.` | Swing the vehicle left or right around the word |
| `Up` and `Down` | Vehicle further from the word, or closer to it |
| `Left` and `Right` | Vehicle to the left or right |
| `F7` | Change which way the vehicle faces: toward the word, away from it, or side-on with its nose to the left or right |
| `F8` | Stop placing |

Left and right are as you see them, looking across the word at the vehicle.

## Using a spot

On foot, look at the word from within a few metres. The game's own prompt comes up, titled "Parking spot":

- **Bring out** (`F`) has the game deliver the spot's vehicle and stands it on the spot. A vehicle that is already out somewhere else is moved here.
- **Choose vehicle** (`R`) opens the game's own vehicle list. The vehicle you pick becomes the spot's vehicle and is brought out.
- **Put away** (`F`) is offered in place of the other two when one of your vehicles is standing on the spot. It is also offered for a vehicle of yours left within eight metres of the spot, as long as no other spot is nearer to it, so you can drive back, pull up and put it away.

A vehicle that is not yours standing on the spot blocks it: the prompt says so and nothing is brought out on top of it.

A new spot starts on the first of your vehicles that no other spot is set to.

## Locking and removing

| Key | Does |
|---|---|
| `F10` | Lock or unlock the spot you are looking at, or else the nearest one within five metres |
| `F8` | Remove the nearest spot within five metres, unless it is locked |

A locked spot shows "(locked)" in its prompt and cannot be removed until it is unlocked. Everything else about it works as before.

Removing every spot at once is done from Mod Settings only (see Options). Removing a spot does not remove the vehicle standing on it.

## Installation

The `r6`, `bin` and `archive` folders are laid out from the game root, so they can be copied into the game directory or zipped together for a mod manager.

Requires:
- [RED4ext](https://github.com/WopsS/RED4ext)
- [redscript](https://github.com/jac3km4/redscript)
- [Codeware](https://github.com/psiberx/cp2077-codeware)
- [TweakXL](https://github.com/psiberx/cp2077-tweak-xl)
- [Cyber Engine Tweaks](https://github.com/maximegmd/CyberEngineTweaks)
- [XUtils](https://www.nexusmods.com/cyberpunk2077/mods/30296)

Optional:
- [Mod Settings](https://github.com/jackhumbert/mod_settings) - adds an in-game options page (see below), which is also where the two "remove all" commands are. Without it the default keys and options apply.

## Options

With Mod Settings installed, under **Parking Spot Spawner**:

| Section | Option | Default |
|---|---|---|
| Key Bindings | Every key above | As above |
| Vehicles | Bring vehicles out through the game's own vehicle call | On |
| Ground Marking | Show the PARKING marking | On |
| Ground Marking | Marking width (cm) | 240 |
| Ground Marking | Marking height (cm) | 60 |
| Remove Parking Spots | Remove all parking spots that are not locked | Off |
| Remove Parking Spots | Remove every parking spot, locked ones too | Off |
| Debug | Debug logging | Off |

- The two **Remove Parking Spots** entries are commands, not settings. Switch one on to remove the spots in the save you are playing. It is done once, when you are back in the game, and the switch turns itself off again. Switched on from the main menu it does nothing.
- The prompt on a spot shows the game's own interaction keys. If you have changed those in the game, set the same keys for "At a parking spot" here.
- With **Bring vehicles out through the game's own vehicle call** off, the mod spawns a copy of the vehicle itself. That works anywhere, but the copy is not treated as your vehicle by the game or by other mods.
- With the marking hidden, a spot is still used by looking at the place where its word would be.
- Debug logging writes what the mod does to the Cyber Engine Tweaks game log.

## Translating

The text the mod shows in game goes through Codeware's localization system, so it can be translated without touching the rest of the code. It is all in `r6/scripts/ParkingSpotSpawner/ParkingSpotSpawnerLocalization.reds`.

The file starts with instructions: copy the English class, translate the second string on each line, and return the new class for your language. English is used for any language without a translation. The Mod Settings page and the painted word are in English only. Translations are welcome as pull requests.

## Notes

- To keep vehicles from vanishing, the mod raises the distance at which the game takes a called vehicle out of the world. This applies to every vehicle you call, not only those on parking spots: a vehicle stays where you left it until you call it somewhere else or put it away at a spot.
- With the game delivering the vehicles, the game's own rules for calling them apply. Where the game would not let you call a vehicle, the spot says it cannot bring one out right now.
- The outline shown while placing is one size for every vehicle.
- The prompt also answers to Square / X and Triangle / Y on a gamepad. Placing, locking and removing are on the keyboard.
- The archive holds two files: the word's shape, and a material that paints it with the game's own road paint.
- Built and tested on game version 2.3x with Codeware 1.20.5, TweakXL 1.11.4 and XUtils 1.0.1.

## Credits

- **CyanideX** for [XUtils](https://www.nexusmods.com/cyberpunk2077/mods/30296), which draws the placement preview and puts the PARKING marking in the world.

Built it with Claude (the AI).

## License

[MIT](LICENSE)
