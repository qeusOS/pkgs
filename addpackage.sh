#!/usr/bin/env bash
REPODIR="$HOME/Projects/qeusOS/pkgs/x86_64"
PKGBUILDDIR="$HOME/Projects/qeusOS/pkgbuild"
REPONAME="qeusOS"
REPOBRANCH="main"

if [ -d "$PKGBUILDDIR"/$1 ]; then
				rm -rf "$PKGBUILDDIR/$1"
fi

if [ "$1" == "" ]; then
				echo "Please type a package name (AUR)."
				exit 1
fi

OLDPWD=$(pwd)

git clone https://aur.archlinux.org/$1.git $PKGBUILDDIR/$1

cd $PKGBUILDDIR/$1

makepkg -s

cp *.pkg.tar.zst $REPODIR/

cd $REPODIR

repo-add $REPONAME.db.tar.gz *.pkg.tar.zst

# If you are using Gitlab or anything else. (Not GitLab)
rm $REPONAME.{db,files}
mv $REPONAME.db.tar.gz $REPONAME.db
mv $REPONAME.files.tar.gz $REPONAME.files

# Push items
git add .
git commit -m "Add $1 package."
git push -u origin $REPOBRANCH
