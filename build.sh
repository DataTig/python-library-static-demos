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
  # Note this only updates the current branch, not any new ones.
  # But as this is only used in local dev at the moment we can live with that.
  git pull
  cd ../..
else
  git clone --branch main https://github.com/DataTig/datatig.github.io.git gitrepos/datatig-website
  cd gitrepos/datatig-website
  # This for loop is from https://stackoverflow.com/a/4754797
  for branch in $(git branch --all | grep '^\s*remotes'| egrep --invert-match '(:?HEAD|main)$'); do
    git branch --track "${branch##*/}" "$branch"
  done
  cd ../..
fi

echo "Build org-id-register"
mkdir -p output/org-id-register/branch
python -m datatig.cli build gitrepos/org-id-register/  --staticsiteoutput output/org-id-register/branch/main --staticsiteurl=/org-id-register/branch/main

echo "Build datatig-website"
mkdir -p output/datatig-website/branch
python -m datatig.cli build gitrepos/datatig-website/  --staticsiteoutput output/datatig-website/branch/main --staticsiteurl=/datatig-website/branch/main
python -m datatig.cli versionedbuild gitrepos/datatig-website/  --allbranches --defaultref main --staticsiteoutput output/datatig-website/versioned --staticsiteurl=/datatig-website/versioned
