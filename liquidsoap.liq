#!/usr/bin/liquidsoap

# Print log messages to the console,
# can also be done by passing the -v option to liquidsoap.
#log.stdout.set(true)

# Music
#myplaylist = playlist("/app/playlist.pls")
myplaylist = playlist("/app/music/")

# Start building the feed with music
radio = myplaylist

# Stream it out
output.icecast(%vorbis, host = "0.0.0.0", port = $PORT, password = "$CFG_SOURCE_PASSWORD", mount = "/live.ogg", radio)