#!/bin/bash
PAK=pak128
wget -q --post-data "version=313&choice=all&submit=Export!"  --delete-after https://translator.simutrans.com/script/main.php?page=wrap
wget -O texts.zip https://makie.de/translator/data/tab/language_pack-Scenario+Tutorial+$PAK.zip
mkdir tmp && cd tmp
unzip ../texts.zip
rsync -avr --exclude='en.tab' --exclude='_objectlist.txt' --exclude='_translate_users.txt' * ..
cd ..
rm -r tmp
rm texts.zip
git diff
select yn in "Commit translations and push" "Keep changes but don't commit" "Cancel and reset"; do
    case $yn in
        "Commit translations and push" ) git add .; git commit -m "Translation: Import texts from Simutranslator"; git push; break;;
		"Keep changes but don't commit" ) break;;
        "Cancel and reset" ) git reset; break;;
    esac
done
