printf 'Preparing Configuration...\n\n'
export CFG_ADMIN_USER=${CFG_ADMIN_USER:-"admin"}
export CFG_ADMIN_PASSWORD=${CFG_ADMIN_PASSWORD:-"hackme"}
export CFG_ADMIN=${CFG_ADMIN:-"icemaster@localhost"}
export CFG_LOCATION=${CFG_LOCATION:-"Earth"}
export CFG_RELAY_PASSWORD=${CFG_RELAY_PASSWORD:-"hackme"}
export CFG_SOURCE_PASSWORD=${CFG_SOURCE_PASSWORD:-"hackme"}
export CFG_STREAM_URL=${CFG_STREAM_URL:-"0.0.0.0"}
export CFG_MUSIC_URL=${CFG_MUSIC_URL:-"none"}

if [ "$CFG_MUSIC_URL" == "none" ]
then
	printf 'No Music Archive to Download. Assuming you either have your music archive pre-uploaded, or your music folder pre-populated with songs? (No link specified in \$CFG_MUSIC_URL)\n'
else
	printf 'Downloading Music Archive $CFG_MUSIC_URL... (Link specified in \$CFG_MUSIC_URL)\n'
	curl -o music.tar.gz -s -L $CFG_MUSIC_URL
fi

if [ -f "music.tar.gz" ]
then
    printf 'Extracting Music Archive to Music Folder...\n'
	tar -xzvf music.tar.gz
else
	printf 'Music Archive Doesn't Exist! Assuming you have your music folder pre-populated with songs?\n'
fi
printf 'Music Prepared!\n\n'

printf 'Building Playlist File...\n\n'
printf '%s\n' "$PWD"/music/*.ogg >> playlist.txt
printf '%s\n' "$PWD"/music/*.mp3 >> playlist.txt

printf 'Building Configuration Files...\n\n'
# ---
sed -i -e "s/\$PORT/$PORT/g" icecast.xml
sed -i -e "s/\$CFG_ADMIN_USER/$CFG_ADMIN_USER/g" icecast.xml
sed -i -e "s/\$CFG_ADMIN_PASSWORD/$CFG_ADMIN_PASSWORD/g" icecast.xml
sed -i -e "s/\$CFG_ADMIN/$CFG_ADMIN/g" icecast.xml
sed -i -e "s/\$CFG_LOCATION/$CFG_LOCATION/g" icecast.xml
sed -i -e "s/\$CFG_RELAY_PASSWORD/$CFG_RELAY_PASSWORD/g" icecast.xml
sed -i -e "s/\$CFG_SOURCE_PASSWORD/$CFG_SOURCE_PASSWORD/g" icecast.xml
sed -i -e "s/\$CFG_STREAM_URL/$CFG_STREAM_URL/g" icecast.xml
# ---
sed -i -e "s/\$PORT/$PORT/g" ices.xml
sed -i -e "s/\$CFG_ADMIN_USER/$CFG_ADMIN_USER/g" ices.xml
sed -i -e "s/\$CFG_ADMIN_PASSWORD/$CFG_ADMIN_PASSWORD/g" ices.xml
sed -i -e "s/\$CFG_ADMIN/$CFG_ADMIN/g" ices.xml
sed -i -e "s/\$CFG_LOCATION/$CFG_LOCATION/g" ices.xml
sed -i -e "s/\$CFG_RELAY_PASSWORD/$CFG_RELAY_PASSWORD/g" ices.xml
sed -i -e "s/\$CFG_SOURCE_PASSWORD/$CFG_SOURCE_PASSWORD/g" ices.xml
sed -i -e "s/\$CFG_STREAM_URL/$CFG_STREAM_URL/g" ices.xml

printf 'Starting Icecast2... (Radio Server)\n\n'
icecast2 -c icecast.xml &

printf 'Waiting for Icecast2 to Startup... (Sleeping for 10 Seconds)\n\n'
sleep 10

printf '\nStarting Ices2... (Audio Streamer)\n\n'
ices2 ices.xml

printf "(Now Sleeping Forever!)\n\nYour Radio Server Webpage should now be Live!\n\nOn your App's Dashboard, Click 'Open app' in the top right to Open your Radio's Webpage!\n\n"
while true
do
	sleep 10
done