#!/bin/bash
# Adapted from:
# topic: http://askubuntu.com/questions/409607/how-to-create-a-customized-ubuntu-server-iso/409651#409651

ISO_VERSION=17.04
ISO_FILE=ubuntu-17.04-server-amd64.iso

#curl -o $ISO_FILE http://releases.ubuntu.com/$ISO_VERSION/$ISO_FILE

echo "Extracting contents of $ISO_FILE"
mkdir -p iso newIso
sudo mount -o loop ./$ISO_FILE ./iso
sudo cp -r ./iso/* ./newIso/
sudo cp -r ./iso/.disk/ ./newIso/    
sudo umount ./iso/

echo "Copying over custom files"
cp -rv src/* newIso

echo "Getting packages"
mkdir -p newIso/dists/stable/extras/binary-i386
cd newIso
sudo apt-ftparchive packages ./pool/extras/ > dists/stable/extras/binary-i386/Packages
sudo gzip -c ./dists/stable/extras/binary-i386/Packages | tee ./dists/stable/extras/binary-i386/Packages.gz > /dev/null
cd ..

echo "Create custom image"
md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txtmextract_iso
mkisofs -J -l -b isolinux/isolinux.bin -no-emul-boot \
    -boot-load-size 4 -boot-info-table -z -iso-level 4 \
    -c isolinux/isolinux.cat -o ./ubuntu-hammer-amd64.iso -joliet-long newIso/

echo "Complete."
