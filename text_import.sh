#!/bin/bash

PAK=pak128

echo "Downloading pak texts"
rm -rf tmp
mkdir tmp
cd tmp
wget -q --post-data "version=19&choice=all&submit=Export!"  --delete-after http://translator.simutrans.com/script/main.php?page=wrap
wget -O texts.zip http://translator.simutrans.com/data/tab/language_pack-$PAK.zip
unzip texts.zip

# only copy changed texts
for f in ./*.tab; do
  cat $f | grep "^[^#]" > $f.tmp
  a=`cat ../pak128.prototype/text/$f | grep "^[^#]" | diff -wq $f.tmp -`
  if [[ ! -z "$a" ]] ; then
    echo "Moving $f to pak texts"
    mv $f ../pak128.prototype/text/
  fi
done

# cleanup
cd ..
rm -fr tmp

# download scenario texts
echo "Downloading scenario texts"
cd pak128.prototype/scenario/tutorial
mkdir tmp
cd tmp

wget -q --post-data "version=313&choice=all&submit=Export!"  --delete-after http://translator.simutrans.com/script/main.php?page=wrap
wget -O texts.zip http://translator.simutrans.com/data/tab/language_pack-Scenario+Tutorial+$PAK.zip
unzip texts.zip
rm texts.zip

# protect en.tab (why???)
rm en.tab

# only copy changed texts
for f in ./*.tab; do
  cat $f | grep "^[^#]" > $f.tmp
  a=`cat ../$f | grep "^[^#]" | diff -wq $f.tmp -`
  if [[ ! -z "$a" ]] ; then
    echo "Moving $f to tutorial texts"
    mv $f ..
  fi
done
rm *.tab *.tab.tmp
rm _*.txt
# copy the rest
cp -r * ..
cd ..
rm -rf tmp
