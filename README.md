### On remote machine
```
echo bashrc >> ~/.bashrc
```

### On local machine
```
mkdir -p ~/.local/bin
cp trigger_remote_editor.sh ~/.local/bin/trigger_remote_editor.sh
chmod +x ~/.local/bin/trigger_remote_editor.sh
```

#### iTerm2 > Profiles > Advanced > Triggers (Edit)

Regex:

`.*ITERM-TRIGGER-remote-editor ([^ ]+) ([^ ]+) ([^ ]+) (([^ ]+ ?)+)`

Run command:

`/Users/USERNAME/.local/bin/trigger_remote_editor.sh \1 \2 \3 \4`