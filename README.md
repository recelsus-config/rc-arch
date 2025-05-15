## Overview

This Dockerfile builds an Arch Linux container with a pre-configured development environment. It installs various tools and sets up configuration files for `nvim`, `tmux`, and `bash` from specified GitHub repositories.

## Features

- Installs essential development tools like `neovim`, `tmux`, `ripgrep`, `fzf`, `fd`, `cmake`, `make`, `clang`, `nodejs`, `npm`, and `jq`.
- Configures a non-root user with `sudo` access.
- Clones configuration files for `nvim`, `tmux`, and `bash` from specified Git repositories.
- Sets up a custom `.bashrc`.

## Usage

Build the Docker image: `docker build -t arch-container .`
Run the container: `docker run -it arch-container`

This will start a `tmux` session within the container.

## Dependencies

- git
- neovim
- tmux
- bash
- ripgrep
- fzf
- fd
- cmake
- make
- clang
- nodejs
- npm
- jq

