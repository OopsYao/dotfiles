# Local PATH
export PATH="$PATH:$HOME/.local/bin"

# https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec wrappedhl
fi
