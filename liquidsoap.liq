#!/usr/bin/liquidsoap

# Hardcoded Library File Loading (Messy and Imperfect but it works for now)
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/error.liq"
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/list.liq"
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/string.liq"
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/log.liq"
%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/stdlib.liq"
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/playlist.liq"

# Include Pervasives Library File
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/pervasives.liq"
#%include "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs/playlist.liq"
#%include "includeallforheroku.liq"

# Configure Library Directory
#set("configure.libdir", "/app/.dpkg/usr/share/liquidsoap/2.1.0/libs")
#set("configure.libdir", "/app/.dpkg/usr/share")

# Log dir
#set("log.file.path","/dev/null")

# Print log messages to the console,
# can also be done by passing the -v option to liquidsoap.
#set("log.stdout", true)

# Music
#mymusic = playlist(mksafe("/app/playlist.pls"))
#mymusic = playlist("/app/playlist.pls")
mymusic = playlist("/app/music")

# Start building the feed with music
radio = mymusic

# Smart Crossfade the radio
radio = smart_crossfade(radio)

# Stream it out
output.icecast(%vorbis, host = "0.0.0.0", port = $PORT, password = "$CFG_SOURCE_PASSWORD", mount = "/live.ogg", public = $CFG_ADVERTISE, fallible = true, radio)