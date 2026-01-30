#!/bin/bash
cp ~/espaces/travail/nebula-5.2.iso /tmp && pkill -f qemu-system-i386 
qemu-system-i386 -net user,hostfwd=tcp::2222-:22 -net nic,model=e1000 -enable-kvm -nographic -cdrom /tmp/nebula-5.2.iso
