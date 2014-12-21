#!/bin/bash

# Watch Maildir inboxes for new mails and send a summary notification with notify-send. Tested and "works perfectly" with dunst.
# Dependencies: inotifywait from inotify-tools package.
maildir_path="{{ user.mail.dir }}"  # Path to Maildir root.
mailboxes=("{{ user.mail.boxes|join('" "') }}") # Mailboxes to watch.

watchdirs=$(for box in ${mailboxes[*]}; do echo ${maildir_path}/$box/new; done)

scriptname=${0##*/}
#multicut_file="/tmp/${scriptname}_${USER}_multipart_cut.txt"
#trimmed_file="/tmp/${scriptname}_${USER}_trimmed.txt"

trim() {
    local var="$1"
    var="${var#"${var%%[![:space:]]*}"}" # Remove leading whitespace characters.
    var="${var%"${var##*[![:space:]]}"}" # Remove trailing whitespace characters.
    echo -n "$var"
}

parse_send() {
    local inbox="$1"
    local mailfile="$2"

    echo $mailfile
    subject=$(cat $2 | egrep '^Subject' | sed -e 's/^Subject://g')
    from=$(cat $2 | egrep '^From' | sed -e 's/^From://g')

    # Send the message with the name this scrip was invoked with.
    notify-send -i /usr/share/icons/Adwaita/22x22/actions/mail-message-new.png ---app-name "$scriptname" "$inbox $from" "$subject"
}

# Debug with static file.
if [ -n "$1" ]; then
    parse_send "debugmail" "$1"
    exit 0
fi

# Let inotifywait monitor changes and output each event on it's own line.
while read mail; do

echo "foo"
    # Split inotify output to get path and the file that was added.
    parts=($(echo "$mail" | sed -e 's/ \(CREATE\|MOVED_TO\) / /'))
    inbox_path="${parts[0]}"
    inbox=$(echo "$inbox_path" | grep -Po "(?<=/)\w+(?=/new)")
    mailfile="${parts[1]}"
    parse_send "$inbox" "${inbox_path}${mailfile}"

done < <(inotifywait --monitor --event create --event moved_to ${watchdirs} 2>/dev/null)
