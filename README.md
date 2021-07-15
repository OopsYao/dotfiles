# Dotfiles

Just dotfiles.

## Setup

This project uses GNU stow to setup config,
e.g., run `stow -t $HOME alacritty` to install the
config of alacritty.

Note that stow won't overwrite existing files by design.
And we may use `--adopt` option to import target files
to the stow package in advance. (which overwrites files
in stow package, and makes target files be the symlinks
to the stow files.)
