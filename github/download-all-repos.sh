#! /bin/bash
CONTEXT=users; # users|orgs
NAME=hughesjs; # username
PAGE=1
curl "https://api.github.com/$CONTEXT/$NAME/repos?page=$PAGE&per_page=100" |
  grep -e 'git_url*' |
  cut -d \" -f 4 |
  xargs -L1 git clone
