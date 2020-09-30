# Wild Rose Dots
add to ~/.bashrc or ~/.zshrc for xserver/pulseaudio support.  
># x410
>export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
>export PULSE_SERVER=tcp:$(grep nameserver /etc/resolv.conf | awk '{print $2}');

![Wild Rose](https://github.com/PumkinNymph/dotfiles/blob/master/images/Wild%20Rose.png)
