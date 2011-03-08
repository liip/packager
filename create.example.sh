# Create a package of packager
svnurl=https://www.example.com/svn/tools/packager/trunk/
root=/tmp/packager-package

[ -d "$root" ] && rm -rf $root
 
mkdir $root
mkdir -p $root/usr/local/lib
svn export $svnurl $root/usr/local/lib/packager

mkdir $root/usr/local/bin
ln -s ../lib/packager/packager.py $root/usr/local/bin/packager

rev=$(svn info $svnurl | grep Revision | sed 's/Revision: //')
mkdir $root/pkg
echo "name: tools-packager
version: $rev" >$root/pkg/info

# Tarfile
cd $root
tar -cvzf ../tools-packager-$rev.tar.gz . || exit 1

# Copy
scp ../tools-packager-$rev.tar.gz \
    www.example.com:/var/packager/tools/packager/
ssh www.example.com "ln -sf ../../../../../packager/tools/packager/tools-packager-$rev.tar.gz /var/www/html/install/packager/latest/tools-packager.tar.gz"
