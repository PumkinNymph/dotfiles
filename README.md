# Wild Rose Dots

add following to ~/.bashrc or ~/.zshrc for xserver/pulseaudio support when using WSL.  


```
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0\
export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');
```

![Wild Rose](https://github.com/PumkinNymph/dotfiles/blob/master/images/Wild%20Rose.png)

Credit for SideDecoration goes to https://github.com/Avaq see https://github.com/xmonad/xmonad/issues/152
