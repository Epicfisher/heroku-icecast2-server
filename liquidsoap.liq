#!/usr/bin/liquidsoap

# Log dir
set("log.file.path","/dev/null")

# Print log messages to the console,
# can also be done by passing the -v option to liquidsoap.
log.stdout.set(true)

# Music
mymusic = playlist.safe("/app/playlist.pls")

# Start building the feed with music
radio = mymusic

# Stream it out
output.icecast(%vorbis, host = "0.0.0.0", port = $PORT, password = "$CFG_SOURCE_PASSWORD", mount = "/live.ogg", public = $CFG_ADVERTISE, fallible = true, radio)