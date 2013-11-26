#!/bin/bash

. ~/.rvm/scripts/rvm

# $ruby variable should be supplied by CI environment (e.g. Jenkins matrix)
# For MRI, variable should be an RVM ruby string (e.g. 1.9.2-p180).  For JRuby,
# format is jruby-version_mode, where 'jruby-version' is an RVM ruby string
# (e.g. jruby-1.6.7) and 'mode' is 1.8 or 1.9.
if [ "${ruby:0:5}" == "jruby" ]; then
  jruby_mode="${ruby#*_}"
  ruby="${ruby/_*}"
  echo Using $ruby in $jruby_mode mode.

  export JRUBY_OPTS="--$jruby_mode"

  gemset=rapportive-bundler_$jruby_mode
  bundle_install="jruby -r openssl -S bundle install"
else
  gemset=rapportive-bundler
  bundle_install="bundle install"
fi

rvm ${ruby}@$gemset

set -ex

rm -f Gemfile.lock

bundle check || $bundle_install --path=vendor/bundle

bundle exec rake
