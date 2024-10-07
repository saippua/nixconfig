# To Run

## Työkone

```sh
sudo nixos-rebuild switch --flake .#tyo
```

## WSL

```sh
sudo nixos-rebuild switch --flake .#wsl --impure
```

Add these to the actions array of the JSON config of Windows Terminal to enable shift+enter and ctrl+enter
```json
        {
            "keys": "shift+enter",
            "command": { "action": "sendInput", "input": "\u001b[13;2u" }
        },
        {
            "keys": "ctrl+enter",
            "command": { "action": "sendInput", "input": "\u001b[13;5u" }
        }
```
