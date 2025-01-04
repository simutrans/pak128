#!/bin/bash

PAK=pak128

echo "Downloading pak128 texts"
rm -rf tmp
mkdir tmp
cd tmp
wget -q --post-data "version=19&choice=all&submit=Export!"  --delete-after https://translator.simutrans.com/script/main.php?page=wrap
wget -O texts.zip https://translator.simutrans.com/data/tab/language_pack-$PAK.zip
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

# download scenario Tutorial
echo "Downloading tutorial scripts"
cd pak128.prototype
cd scenario
rm -rf tutorial
wget -O main.zip https://codeload.github.com/simutrans/tutorial_multipak/zip/refs/heads/main
unzip main.zip
mv tutorial_multipak-main tutorial
rm -f tutorial/text_import.sh
rm -f tutorial/.gitignore
rm -f tutorial/tutorial64g.sve
rm -f tutorial/tutorial64.sve
rm -f tutorial/README.md
rm -f tutorial/set_data.nut
rm -rf tutorial/.github
cp ../../set_data.nut tutorial/set_data.nut
cd tutorial
rm -rf original_text
rm -rf info_files
cd ..
rm -f main.zip

# download scenario texts
echo "Downloading scenario texts"
cd tutorial

#wget -q --post-data "version=312&choice=all&submit=Export!"  --delete-after https://translator.simutrans.com/script/main.php?page=wrap
#wget -O texts.zip https://translator.simutrans.com/data/tab/language_pack-Scenario+Tutorial+$PAK.zip
wget -q --delete-after "https://simutrans-germany.com/translator_page/scenarios/scenario_5/download.php"
wget -O texts.zip "https://simutrans-germany.com/translator_page/scenarios/scenario_5/data/language_pack-Scenario+Tutorial+multipak.zip"
unzip -o texts.zip
rm texts.zip
rm -f _*.txt
rm -f translate_users.txt
cd ..
