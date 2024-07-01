#!/bin/bash

echo "Clone/update data repositories"
mkdir -p gitrepos

if [ -d gitrepos/org-id-register ]; then
  cd gitrepos/org-id-register
  git pull
  cd ../..
else
  git clone --branch main https://github.com/org-id/register.git gitrepos/org-id-register
fi

if [ -d gitrepos/datatig-website ]; then
  cd gitrepos/datatig-website
  git pull
  cd ../..
else
  git clone --branch main https://github.com/DataTig/datatig.github.io.git gitrepos/datatig-website
fi

echo "Build org-id-register"
mkdir -p output/org-id-register/branch
python -m datatig.cli build gitrepos/org-id-register/  --staticsiteoutput output/org-id-register/branch/main --staticsiteurl=/org-id-register/branch/main

echo "Build datatig-website"
mkdir -p output/datatig-website/branch
python -m datatig.cli build gitrepos/datatig-website/  --staticsiteoutput output/datatig-website/branch/main --staticsiteurl=/datatig-website/branch/main
