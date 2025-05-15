## 🐧 rc-arch: Arch Linux Development Container

### ✅ Installation

```bash
docker pull ghcr.io/recelsus-config/rc-arch:latest
```

### ✅ Usage (with Docker Compose)

1. Make sure `docker-compose.yaml` is available in the project root (already included).
2. Start the container in the background:

```bash
docker compose up -d
```

3. Attach to the running `tmux` session:

```bash
docker exec -it rc-arch tmux
docker exec -it rc-arch tmux a
```

* The container remains active thanks to `tmux` running as the main process.
* You can create or switch sessions manually using `tmux new -As dev` or similar.

---

## 🧰 Features

* 🛠️ **Pre-installed development tools**, including:

  * `neovim`, `tmux`, `ripgrep`, `fzf`, `fd`, `jq`
  * `cmake`, `make`, `clang`, `nodejs`, `npm`
* 👤 **Non-root user (`arch`) with passwordless sudo**
* 🧩 **Automatically clones configuration files** for:

  * `nvim`, `tmux`, and `bash` from your GitHub repositories
* 🧾 **Custom `.bashrc` sourced automatically**

---

## 📦 Included Packages

* git
* neovim
* tmux
* bash
* ripgrep
* fzf
* fd
* cmake
* make
* clang
* nodejs
* npm
* jq

---

## 📝 Notes

* The container is based on [`archlinux:latest`](https://hub.docker.com/_/archlinux).
* Builds and pushes to [GitHub Container Registry (GHCR)](https://ghcr.io) are automated via GitHub Actions.
* Configuration repositories are expected to be public or accessible via HTTPS.

---

Let me know if you'd like to include:

* A sample `docker-compose.yml`
* Preconfigured `tmux.conf` behavior
* Shared volumes for host-container integration

Happy to help tailor it for team collaboration or onboarding documentation!

