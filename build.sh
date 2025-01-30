#!/bin/bash

set -e

mkdir -p gitrepos

checkout() {
  echo "Checkout ${1}"
  if [ -d gitrepos/${1} ]; then
    cd gitrepos/${1}
    git pull
    # Note this only updates the current branch, not any new ones.
    # But as this is only used in local dev at the moment we can live with that.
    cd ../..
  else
    git clone --branch ${3} ${2} gitrepos/${1}
    cd gitrepos/${1}
    # This for loop is from https://stackoverflow.com/a/4754797
    for branch in $(git branch --all | grep '^\s*remotes'| egrep --invert-match ${4}); do
      git branch --track "${branch##*/}" "$branch"
    done
    cd ../..
  fi
}

build() {
  echo "Build ${1}"
  mkdir -p output/${1}/branch
  python -m datatig.cli build gitrepos/${1}/  --staticsiteoutput output/${1}/branch/${2} --staticsiteurl=$DATATIG_BASE_URL/${1}/branch/${2}
  python -m datatig.cli versionedbuild gitrepos/${1}/  --allbranches --defaultref ${2} --staticsiteoutput output/${1}/versioned --staticsiteurl=$DATATIG_BASE_URL/${1}/versioned
}

checkout datatig-website https://github.com/DataTig/datatig.github.io.git main '(:?HEAD|main)$'
checkout org-id-register https://github.com/org-id/register.git main '(:?HEAD|main)$'
checkout oc4ids-registry https://github.com/OpenDataServices/oc4ids-registry.git live '(:?HEAD|live)$'

build datatig-website main
build org-id-register main
build oc4ids-registry live
