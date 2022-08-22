#!/usr/bin/liquidsoap

# Print log messages to the console,
# can also be done by passing the -v option to liquidsoap.
set("log.stdout", true)

# Music
musicplaylist = playlist("playlist.txt")

# Start building the feed with music
radio = musicplaylist

# Stream it out
output.icecast(%vorbis, host = "0.0.0.0", port = $PORT, password = "$CFG_SOURCE_PASSWORD", mount = "/live.ogg", radio)