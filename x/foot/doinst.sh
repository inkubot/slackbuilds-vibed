#!/bin/sh
# foot post-install actions.
#
# 1. Place the default foot.ini from the .new file only if the user has not
#    already created one (never clobber an existing user config on upgrade).
config() {
    if [ ! -e "/$1" ]; then
        if [ -e "/$1.new" ]; then
            mv -f "/$1.new" "/$1" 2>/dev/null
        elif [ -e "/$2" ]; then
            cp -a "/$2" "/$1" 2>/dev/null
            chmod 0644 "/$1" 2>/dev/null
            chown root:root "/$1" 2>/dev/null
        fi
    else
        [ -e "/$1.new" ] && rm -f "/$1.new" 2>/dev/null
    fi
}
config /etc/xdg/foot/foot.ini /etc/xdg/foot/foot.ini.new

# 2. Refresh the desktop database (foot.desktop, foot-server.desktop,
#    footclient.desktop).
if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q /usr/share/applications 2>/dev/null || true
fi

# 3. Refresh the icon cache (foot.svg, foot.png).
if [ -x /usr/bin/gtk-update-icon-cache ]; then
    /usr/bin/gtk-update-icon-cache -q -t /usr/share/icons/hicolor 2>/dev/null || true
fi

exit 0
