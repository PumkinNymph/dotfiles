# Wild Rose Dots

add following to ~/.bashrc or ~/.zshrc for xserver/pulseaudio support when using WSL.  
see\
https://x410.dev/cookbook/wsl/using-x410-with-wsl2
https://x410.dev/cookbook/wsl/enabling-sound-in-wsl-ubuntu-let-it-sing/

```
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0\
export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
```

![Wild Rose](https://github.com/PumkinNymph/dotfiles/blob/master/images/Wild%20Rose.png)

Credit for SideDecoration goes to https://github.com/Avaq see https://github.com/xmonad/xmonad/issues/152
