# Spawner Plugin

A lightweight Godot plugin for managing spawn waves in 2D and 3D.

## Git Repository

Source code is available on GitHub:

<https://github.com/VillerotJustin/spawner-plugin>

## Demo

A simple demo is included in this repository: open the test scenes in the `TestScenes/` folder and run them in the Godot editor to see the plugin in action.

- `TestScenes/Test_2D_scene.tscn` — 2D demonstration scene
- `TestScenes/Test_3D_scene.tscn` — 3D demonstration scene

These scenes contain usage examples of the scripts provided in `addons/spawner/`.

## Example Project

The repository contains everything needed to launch and test the plugin locally:

- The root Godot project (`project.godot`).
- The plugin and its scripts are in `addons/spawner/`:
  - `spawner.gd`, `spawner_2d.gd`, `spawner_3d.gd`
  - `wave.gd`, `wave_entry.gd`

To test quickly:

1. Open this folder in the Godot editor (File → Open → select the project folder or `project.godot`).
2. In the Godot editor, go to Project → Project Settings → Plugins and enable the `Spawner` plugin (if it appears).
3. Open `TestScenes/Test_2D_scene.tscn` or `TestScenes/Test_3D_scene.tscn` and press "Play" to run the test scene.

If your version of Godot doesn't directly display the plugin in the Plugins window, make sure the `addons/spawner/` folder is present at the project root, then restart the editor.

## Documentation — Main Features

Here are the main features exposed by the plugin:

- Support for 2D and 3D spawns (separate scripts for each context).
- Definition of waves composed of entries (wave entries) — structure to configure which entities appear and when.
- Provides ready-to-use scenes/examples in `TestScenes/` to see the mechanics without additional configuration.

Basic usage:

- The `addons/spawner/` folder contains the plugin's scripts and resources. Inspect the scripts (e.g. `spawner_2d.gd` and `spawner_3d.gd`) to learn about extension points and configurable properties.
- Example scenes show how to attach/configure the spawner in a scene. Open them to copy parameters or use as a base.

For detailed API documentation, see `DOCS.md`.

## Godot Asset Library

This plugin is available on the Godot Asset Library:

<https://godotengine.org/asset-library/asset/4498>

## Contributing

Contribute via issues or pull requests on the GitHub repository:

<https://github.com/VillerotJustin/spawner-plugin/issues>

## License

Please refer to the LICENSE file for licensing information.
