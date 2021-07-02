#!/bin/sh -l

echo "ls ."
ls .

echo "======="
echo "ls /"
ls /

echo "====="
echo "ls /github/workspace"
ls /github/workspace

exit 0

# find . -name \*.info -exec touch '{}' \;
# touch ./texk/detex/detex-src/detex.c
# touch ./texk/detex/detex-src/detex.h
# touch ./texk/gregorio/gregorio-src/src/gabc/gabc-score-determination.c
# touch ./texk/gregorio/gregorio-src/src/gabc/gabc-score-determination.h
# touch ./texk/gregorio/gregorio-src/src/vowel/vowel-rules.h
# touch ./texk/web2c/omegafonts/pl-lexer.c
# touch ./texk/web2c/omegafonts/pl-parser.c
# touch ./texk/web2c/omegafonts/pl-parser.h
# touch ./texk/web2c/otps/otp-lexer.c
# touch ./texk/web2c/otps/otp-parser.c
# touch ./texk/web2c/otps/otp-parser.h
# touch ./texk/web2c/web2c/web2c-lexer.c
# touch ./texk/web2c/web2c/web2c-parser.c
# touch ./texk/web2c/web2c/web2c-parser.h
# touch ./utils/asymptote/camp.tab.cc
# touch ./utils/asymptote/camp.tab.h
# touch ./utils/lacheck/lacheck.c
# touch ./utils/xindy/xindy-src/tex2xindy/tex2xindy.c

env:
  global:
    - TL_MAKE_FLAGS="-j 2"

# disable direct build, we don't need to build x86=64-linux two times
#    - os: linux
#      addons:
#        apt:
#          packages:
#            - libfontconfig-dev
#            - libx11-dev
#            - libxmu-dev
#            - libxaw7-dev
#      script: ./Build -C

matrix:
  include:
    - os: linux
      services: docker
      env:
      - tldir=x86_64-linux
      - package=texlive-bin-x86_64-linux.tar.gz
      script: |
        docker run \
        -e TL_MAKE_FLAGS="${TL_MAKE_FLAGS}" \
        -v ${TRAVIS_BUILD_DIR}:/texlive -w /texlive \
        -it --rm debian:jessie sh -c \
        "apt-get update; apt-get install -y --no-install-recommends bash gcc g++ make perl libfontconfig-dev libx11-dev libxmu-dev libxaw7-dev build-essential ; ./Build -C"
    - os: linux
      services: docker
      env:
      - tldir=i386-linux
      - package=texlive-bin-i386-linux.tar.gz
      script: |
        docker run \
        -e TL_MAKE_FLAGS="${TL_MAKE_FLAGS}" \
        -v ${TRAVIS_BUILD_DIR}:/texlive -w /texlive \
        -it --rm i386/debian:jessie sh -c \
        "apt-get update; apt-get install -y --no-install-recommends bash gcc g++ make perl libfontconfig-dev libx11-dev libxmu-dev libxaw7-dev build-essential ; ./Build -C"
    - os: linux
      services: docker
      env:
      - tldir=x86_64-linuxmusl
      - package=texlive-bin-x86_64-musl.tar.gz
      script: |
        docker run \
        -e TL_MAKE_FLAGS="${TL_MAKE_FLAGS}" \
        -v ${TRAVIS_BUILD_DIR}:/texlive -w /texlive \
        -it --rm alpine:3.2 sh -c \
        "apk update; apk add --no-progress bash gcc g++ make perl fontconfig-dev libx11-dev libxmu-dev libxaw-dev; ./Build -C"
#    - os: osx
#      osx_image: xcode7.3
#      env:
#      - tldir=x86_64-darwin
#      - package=texlive-bin-x86_64-darwin.tar.gz
#      before_script:
#      script: ./Build -C

# somehow all binaries are always put into x86_64-pc-linux-gnu, probably
# because this is the architecture travis-ci is running on.
# Rename to the currently built architecture.
before_deploy:
  - if [ -n "$package" ]; then sudo mv inst/bin/* inst/bin/$tldir ; tar czvf ${package} -C inst/bin .; fi
  - if [ -r inst/bin/*/luahbtex ] ; then cp inst/bin/*/luahbtex luahbtex.$tldir ; fi
  - if [ -r inst/bin/*/luajithbtex ] ; then cp inst/bin/*/luajithbtex luajithbtex.$tldir ; fi

deploy:
  - provider: releases
    api_key: $GH_TOKEN
    file: $package
    skip_cleanup: true
    on:
      tags: true
      condition: $package != ""

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
