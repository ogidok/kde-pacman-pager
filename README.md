# Pacman Workspaces for KDE Plasma 6
## Preview
<img width="201" height="37" alt="image" src="https://github.com/user-attachments/assets/c9732fb6-6487-4825-8097-3e746a4f8a3a" />


A minimal and playful virtual desktop pager for KDE Plasma 6, inspired by Pac-Man. 

* Active workspace is represented by a Pac-Man icon (󰮯) using your system's accent color.
* Inactive workspaces containing windows are represented by classic colored ghosts (󰊠) - Blinky, Pinky, Inky, and Clyde.
* Empty workspaces are automatically hidden to keep your panel clean.
* Uses native KDE `TaskManager` and `DBus` APIs for zero-polling instant reactivity.

## Dependencies
- KDE Plasma 6
- A Nerd Font installed and set as your system font (to render the icons correctly).

## Installation

### Method 1: Graphical Interface (GUI)
1. Go to the [Releases](../../releases) tab on GitHub and download the `.plasmoid` file.
2. Right-click on your KDE panel and select **Add Widgets...**
3. Click on **Get New Widgets...** in the top right corner.
4. Select **Install from local file...**
5. Choose the `.plasmoid` file you just downloaded.

### Method 2: Command Line (CLI)
If you cloned the repository or extracted the source code:

```bash
# To install:
kpackagetool6 --type Plasma/Applet --install com.ogidok.pacmanworkspaces

# To upgrade an existing installation:
kpackagetool6 --type Plasma/Applet --upgrade com.ogidok.pacmanworkspaces
```

## How to build the .plasmoid file (For Developers)
A `.plasmoid` file is simply a ZIP archive containing the package structure. To create one, run:

```bash
cd com.ogidok.pacmanworkspaces
zip -r ../pacman-workspaces-v1.0.plasmoid *
```
