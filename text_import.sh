#!/bin/bash

wget -q --post-data "version=19&choice=all&submit=Export!"  --delete-after https://translator.simutrans.com/script/main.php?page=wrap
wget -O texts.zip https://makie.de/translator/data/tab/language_pack-pak128.zip

rm -rf tmp
mkdir tmp
cd tmp
unzip ../texts.zip

# only copy changed texts
for f in ./*.tab; do
  cat $f | grep "^[^#]" > $f.tmp
  cat ../pak128.prototype/text/$f | grep "^[^#]" > ../pak128.prototype/text/$f.tmp
  a=$(diff -wq $f.tmp ../pak128.prototype/text/$f.tmp)
  if [[ ! -z "$a" ]] ; then
    echo "Moving $f to pak texts"
    mv $f ../pak128.prototype/text/
  fi
  rm ../pak128.prototype/text/$f.tmp
done

# cleanup
cd ..
rm -fr tmp
rm texts.zip

# download scenario texts
cd pak128.prototype/scenario/tutorial
./text_import.sh