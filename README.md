# setup-coder

Personal config files for Coder workspaces.

## Usage

To update configs in a workspace based on local checkout:

```sh
./update <workspace>
```

`install` is used by Coder during workspace init.

## SSH

Recommended local `~/.ssh/config` defaults for remote work:

```sshconfig
Host *
  ServerAliveInterval 30
  ServerAliveCountMax 3
  ControlMaster auto
  ControlPath ~/.ssh/cm/%C
  ControlPersist 10m
```

Create the control socket directory once:

```sh
mkdir -p ~/.ssh/cm
chmod 700 ~/.ssh/cm
```

This keeps dead SSH sessions from hanging forever and makes repeated `ssh`,
`scp`, `rsync`, and Git-over-SSH commands reuse the same connection.

## Clipboard

Remote Neovim uses OSC52 over SSH/tmux so normal `y`/`p` use the local
clipboard via Ghostty. On the local Mac, Ghostty must allow clipboard reads:

```ini
clipboard-read = allow
clipboard-write = allow
```

`clipboard-read = ask` is safer, but normal-mode `p` may prompt or stall.
