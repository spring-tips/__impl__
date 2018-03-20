#!/bin/bash

bootstrap=_impl_
st_dir=${ST_CODE:-${HOME}/spring-tips-code-test} # set $ST_CODE to control where this is
export ST_CODE=$st_dir
mkdir -p $st_dir
full_bootstrap=$st_dir/$bootstrap
[[ -e $full_bootstrap ]] || git clone git@github.com:spring-tips/_impl_.git $full_bootstrap
cd $full_bootstrap/github/
pwd 
ls




