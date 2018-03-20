#!/bin/bash

bootstrap=_impl_
st_dir=spring-tips-code
mkdir -p $HOME/$st_dir/
full_bootstrap=$HOME/$st_dir/$bootstrap
echo $full_bootstrap
[[ -e $full_bootstrap ]] && echo "directory exists." || echo "no directory."
exit
git clone git@github.com:spring-tips/_impl_.git
