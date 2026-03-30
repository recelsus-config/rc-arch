## rc-arch

`ghcr.io/recelsus-config/rc-arch:latest` を使って再展開可能な Arch Linux 開発コンテナを扱うためのリポジトリです。

このリポジトリには以下が含まれます。

- イメージのビルド定義: [`docker/Dockerfile`](docker/Dockerfile)
- ビルド時設定: [`build.config`](build.config)
- 実行用ラッパースクリプト: [`rc-arch`](rc-arch)
- 実行時設定の例: [`rc-arch.config.example`](rc-arch.config.example)

### Image

```bash
docker pull ghcr.io/recelsus-config/rc-arch:latest
```

### rc-arch

`rc-arch` は対象イメージ専用の薄い Docker ラッパーです。
`run` と `exec` では `--detach-keys "ctrl-\\"` を付けて起動します。

```bash
rc-arch help
rc-arch run
rc-arch exec
rc-arch stop
rc-arch remove
rc-arch pull
```

主なコマンド:

- `rc-arch run`
  新しいコンテナを起動します。コマンド省略時は `/bin/bash` を実行します。
- `rc-arch exec`
  既存の起動中コンテナに入ります。コマンド省略時は `/bin/bash` を実行します。
- `rc-arch stop`
  既存コンテナを停止します。`--remove` 付きで停止後に削除します。
- `rc-arch remove`
  停止して削除します。`stop --remove` の別導線です。
- `rc-arch pull`
  最新イメージを `docker pull` します。

よく使う例:

```bash
rc-arch run
rc-arch run -n work
rc-arch run --rm
rc-arch run --host-uid
rc-arch run --network mynet -p 3000:3000 -v "$PWD:/workspace"
rc-arch exec
rc-arch exec -n work
rc-arch stop --remove
rc-arch stop --all --remove
```

### Runtime Config

`rc-arch run` は、存在する場合だけ `~/.config/rc-arch/rc-arch.conf` を読み込みます。
ファイルがなければそのまま通常起動します。設定を無視したい場合は `--no-config` を使います。

この設定では次を事前定義できます。

- `RC_ARCH_ENV_NAMES`
  ホスト環境からコンテナへ受け渡してよい env 名
- `RC_ARCH_ENV_VALUES`
  コンテナ内へ固定値で設定する `NAME=value`
- `RC_ARCH_NETWORK`
  既定の `--network`
- `RC_ARCH_PORTS`
  既定の `-p`
- `RC_ARCH_VOLUMES`
  既定の `-v`

優先順位:

- `RC_ARCH_ENV_VALUES` は同名の `RC_ARCH_ENV_NAMES` より優先されます
- `--network` は `RC_ARCH_NETWORK` より優先されます
- `--host-uid` は config の `USER_UID=...` より優先されます
- `-p` と `-v` は config の値に追加されます

設定例:

```bash
mkdir -p ~/.config/rc-arch
cp /home/reg/Project/rc-arch/rc-arch.config.example ~/.config/rc-arch/rc-arch.conf
```

例:

```bash
RC_ARCH_ENV_NAMES=(
    OPENAI_API_KEY
)

RC_ARCH_ENV_VALUES=(
    "USER_UID=1001"
    "OPENAI_BASE_URL=https://example.invalid/v1"
)

RC_ARCH_NETWORK="devnet"

RC_ARCH_PORTS=(
    "3000:3000"
)

RC_ARCH_VOLUMES=(
    "$HOME/.ssh:/home/arch/.ssh:ro"
    "$PWD:/workspace"
)
```

この場合:

- ホストにある `OPENAI_API_KEY` はコンテナへ引き継がれます
- `USER_UID=1001` によりコンテナ内ユーザー `arch` の UID は起動時に 1001 へ調整されます
- `OPENAI_BASE_URL` はコンテナ内だけ固定値になります
- `.ssh` や作業ディレクトリのマウント、既定ネットワーク、ポート公開も自動で付きます

### Build Config

[`build.config`](build.config) は Docker イメージのビルド時設定です。
ここではインストールするパッケージや、コンテナ内へ clone する設定リポジトリを定義しています。

```bash
docker build -f docker/Dockerfile -t rc-arch .
```

### Notes

- ベースイメージは `archlinux:latest` です
- コンテナ内ユーザーは `arch` です
- デフォルトの UID/GID は `1000:1000` です
- `USER_UID` を渡すと起動時に `arch` の UID だけ変更できます
- `arch` は補助グループとして `wheel` に参加しています
- `rc-arch` が対象にするのは `ghcr.io/recelsus-config/rc-arch:latest` 由来のコンテナです
