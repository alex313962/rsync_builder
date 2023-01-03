#$key_location
#$ssh_port
#$remote_user
#$address
#$local_path
#$remote_path
parameters=();
search_dir="/usr/local/bin/rsync_builder/config";
avaiable_config=();

main () {
        for entry in `ls $search_dir`; do
                avaiable_config+=($entry);
        done
        avaiable_config+=("add new +");

        PS3='Please enter your choice: '
        select opt in "${avaiable_config[@]}"
        do
                SELECTED_CONFIG=$opt;
                break;
        done
        if [ "$opt" = "add new +" ];
        then
                create_file;
        else
                check_parameter;
        fi;

}


check_parameter () {
        while read line;
        do
                parameters+=($line)
        done < config/$SELECTED_CONFIG
        echo "this is the designed config, continue?";
        echo "key location = " ${parameters[0]};
        echo "ssh port = " ${parameters[1]};
        echo "remote user = " ${parameters[2]};
        echo "address = " ${parameters[3]};
        echo "local path = " ${parameters[4]};
        echo "remote path = " ${parameters[5]};
        echo "rsync -avzh --progress --delete-after -e 'ssh -i ${parameters[0]} -p ${parameters[1]}' ${parameters[4]} ${parameters[2]}@${parameters[3]}:${parameters[5]}";
}

create_file () {
#get all file information from user 
        echo -n "insert the ssh key location "; 
        read NEW_KEY_LOCATION;
        echo -n "insert the ssh port, left blank for the standard 22 port ";
        read NEW_SSH_PORT;
        echo -n "insert the remote user ";
        read NEW_REMOTE_USER;
        echo -n "insert the server address ";
        read NEW_ADDRESS;
        echo -n "insert the local path ";
        read NEW_LOCAL_PATH;
        echo -n "insert the remote path ";
        read NEW_REMOTE_PATH;
        echo -n "write the name of configuration, leave blank for the standard remote_user@address ";
        read CONFIG_NAME;
#check if i have to generate the file name
        if [ -z "$CONFIG_NAME" ];
        then
                CONFIG_NAME="$NEW_REMOTE_USER@$NEW_ADDRESS";
                echo $CONFIG_NAME;
        fi
#check if there is a custom port
        if [ -z "$NEW_SSH_PORT" ];
        then
                NEW_SSH_PORT="22";
        fi
#check if a file with that name already exist
        if [ -e "/usr/local/bin/rsync_builder/config/$CONFIG_NAME" ];
        then
                echo "File /usr/local/bin/rsync_builder/config/$CONFIG_NAME already exists!";
        else
                COMPLETE_PATH="/usr/local/bin/rsync_builder/config/$CONFIG_NAME";
                echo $COMPLETE_PATH;
                echo $NEW_KEY_LOCATION > $COMPLETE_PATH
                echo $NEW_SSH_PORT >> $COMPLETE_PATH
                echo $NEW_REMOTE_USER >> $COMPLETE_PATH
                echo $NEW_ADDRESS >> $COMPLETE_PATH
                echo $NEW_LOCAL_PATH >> $COMPLETE_PATH
                echo $NEW_REMOTE_PATH >> $COMPLETE_PATH
        fi
        avaiable_config=();
        main;
}

main;


