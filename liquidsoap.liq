#!/usr/bin/liquidsoap

# Music
musicplaylist = playlist("playlist.txt")

# Start building the feed with music
radio = musicplaylist

# Stream it out
output.icecast(%vorbis, host = "0.0.0.0", port = $PORT, password = $PASSWORD, mount = "/live.ogg", radio)