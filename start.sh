printf 'Preparing Configuration...\n\n'
# ---
export CFG_ADMIN_USER=${CFG_ADMIN_USER:-"admin"}
export CFG_ADMIN_PASSWORD=${CFG_ADMIN_PASSWORD:-"hackme"}
export CFG_ADMIN=${CFG_ADMIN:-"icemaster@localhost"}
export CFG_LOCATION=${CFG_LOCATION:-"Earth"}
export CFG_RELAY_PASSWORD=${CFG_RELAY_PASSWORD:-"hackme"}
export CFG_SOURCE_PASSWORD=${CFG_SOURCE_PASSWORD:-"hackme"}
export CFG_STREAM_URL=${CFG_STREAM_URL:-"0.0.0.0"}
export CFG_MUSIC_URL=${CFG_MUSIC_URL:-"none"}
export CFG_GENRE=${CFG_GENRE:-"Unknown"}
export CFG_STREAM_NAME=${CFG_STREAM_NAME:-"Heroku Icecast2 Live Radio"}
export CFG_STREAM_DESCRIPTION=${CFG_STREAM_DESCRIPTION:-"A Heroku-powered Icecast2 Live Radio Server"}
export CFG_HOSTNAME=${CFG_HOSTNAME:-"0.0.0.0"}
export CFG_ADVERTISE=${CFG_ADVERTISE:-"0"}

printf 'Building Configuration Files...\n\n'
# ---
sed -i -e "s/\$PORT/$PORT/g" icecast.xml
sed -i -e "s/\$CFG_ADMIN_USER/$CFG_ADMIN_USER/g" icecast.xml
sed -i -e "s/\$CFG_ADMIN_PASSWORD/$CFG_ADMIN_PASSWORD/g" icecast.xml
sed -i -e "s/\$CFG_ADMIN/$CFG_ADMIN/g" icecast.xml
sed -i -e "s/\$CFG_LOCATION/$CFG_LOCATION/g" icecast.xml
sed -i -e "s/\$CFG_RELAY_PASSWORD/$CFG_RELAY_PASSWORD/g" icecast.xml
sed -i -e "s/\$CFG_SOURCE_PASSWORD/$CFG_SOURCE_PASSWORD/g" icecast.xml
sed -i -e "s/\$CFG_STREAM_URL/${CFG_STREAM_URL//\//\\/}/g" icecast.xml
sed -i -e "s/\$CFG_GENRE/$CFG_GENRE/g" icecast.xml
sed -i -e "s/\$CFG_STREAM_NAME/$CFG_STREAM_NAME/g" icecast.xml
sed -i -e "s/\$CFG_STREAM_DESCRIPTION/$CFG_STREAM_DESCRIPTION/g" icecast.xml
sed -i -e "s/\$CFG_HOSTNAME/${CFG_HOSTNAME//\//\\/}/g" icecast.xml
sed -i -e "s/\$CFG_ADVERTISE/$CFG_ADVERTISE/g" icecast.xml
# ---
sed -i -e "s/\$PORT/$PORT/g" ices.xml
sed -i -e "s/\$CFG_ADMIN_USER/$CFG_ADMIN_USER/g" ices.xml
sed -i -e "s/\$CFG_ADMIN_PASSWORD/$CFG_ADMIN_PASSWORD/g" ices.xml
sed -i -e "s/\$CFG_ADMIN/$CFG_ADMIN/g" ices.xml
sed -i -e "s/\$CFG_LOCATION/$CFG_LOCATION/g" ices.xml
sed -i -e "s/\$CFG_RELAY_PASSWORD/$CFG_RELAY_PASSWORD/g" ices.xml
sed -i -e "s/\$CFG_SOURCE_PASSWORD/$CFG_SOURCE_PASSWORD/g" ices.xml
sed -i -e "s/\$CFG_STREAM_URL/${CFG_STREAM_URL//\//\\/}/g" ices.xml
sed -i -e "s/\$CFG_GENRE/$CFG_GENRE/g" ices.xml
sed -i -e "s/\$CFG_STREAM_NAME/$CFG_STREAM_NAME/g" ices.xml
sed -i -e "s/\$CFG_STREAM_DESCRIPTION/$CFG_STREAM_DESCRIPTION/g" ices.xml
sed -i -e "s/\$CFG_HOSTNAME/${CFG_HOSTNAME//\//\\/}/g" ices.xml
sed -i -e "s/\$CFG_ADVERTISE/$CFG_ADVERTISE/g" ices.xml

printf "Fixing Radio Files... (Copying '~/.apt/usr/share/icecast2/web/.' to '~/.apt/etc/icecast2/web/.')\n\n"
cp -na ~/.apt/usr/share/icecast2/web/. ~/.apt/etc/icecast2/web/.
#printf '1' > ~/.apt/etc/icecast2/web/listeners.txt

#printf 'Fixing Radio Stats JSON Page... (status-json.xsl)\n\n'
#sleep 2
#rm ~/.apt/etc/icecast2/web/status-json.xsl
#sleep 2
#ln -s ~/.apt/usr/share/icecast2/web/status-json.xsl ~/.apt/etc/icecast2/web/status-json.xsl

printf 'Starting Icecast2... (Radio Server)\n\n'
~/.apt/usr/bin/icecast2 -c icecast.xml &

printf 'Waiting for Icecast2 to Startup... (Sleeping for 10 Seconds)\n\n'
sleep 10

if [ "$CFG_MUSIC_URL" == "none" ]
then
	printf "No Music Archive to Download. Assuming you either have your Music Archive pre-uploaded, or your music folder pre-populated with songs? (No link specified in \$CFG_MUSIC_URL)\n"
else
	printf "Downloading Music Archive '$CFG_MUSIC_URL'... (Link specified in \$CFG_MUSIC_URL)\n"
	curl -o music.tar.gz -s -L $CFG_MUSIC_URL
fi

if [ -e music.tar.gz ]
then
    printf "Extracting Music Archive to Music Folder...\n"
	tar -xzvf music.tar.gz -C music/ --strip-components 1
	printf "Cleanup: Deleting Now-Extracted Music Archive...\n"
	rm music.tar.gz
else
	printf "Music Archive Doesn't Exist! Assuming you have your music folder pre-populated with songs?\n"
fi
printf 'Music Prepared!\n\n'

printf 'Building Playlist File...\n\n'
printf '%s\n' "$PWD"/music/*.ogg >> playlist.txt
printf '%s\n' "$PWD"/music/*.mp3 >> playlist.txt

printf '\nStarting Ices2... (Audio Streamer)\n\n'
ices2 ices.xml

printf "(Now Sleeping Forever!)\n\nYour Radio Server Webpage should now be Live!\n\nOn your App's Dashboard, Click 'Open app' in the top right to Open your Radio's Webpage!\n\n"
while true
do
	sleep 10
done