#!/bin/bash
#Automatically generate a set of po and md files for 
#Localization in the ./locales/[language]/ folder
#requirement: pip install mdpo

pip3 install mdpo

width=71

for dir in docs/locales/*/; do
  dir=${dir%*/}
  dir=${dir##*/}
  echo "Updating $dir"
  for file in docs/*.md; do
    mdfile=${file/docs\//} #Remove docs/
    mdfilepath=docs/$mdfile #add docs/ 
    if [ $dir = "en" ]; then
      pofile=${mdfile//.md/.pot} #replace .md with .pot
    else
      pofile=${mdfile//.md/.po} #replace .md with .po
    fi
    pofilepath=docs/locales/$dir/LC_MESSAGES/$pofile #Add target directory 
    #to pofile
    targetmdfile=docs/locales/$dir/$mdfile #Add target directory to mdfile
    echo "Converting $mdfile to $pofile"
    command="md2po ${PWD}/$mdfilepath --md-encoding utf-8 --po-encoding utf-8 \
    -e utf-8 -w $width -q -s -c --po-filepath ${PWD}/$pofilepath"
    echo "$command"
    $($command)
    echo "Converting $pofile to $mdfile"
    command="po2md ${PWD}/$mdfilepath --md-encoding utf-8 --po-encoding utf-8 \
    -p ${PWD}/$pofilepath -q -s ${PWD}/$targetmdfile"
    echo "$command"
    $($command)
  done
done
