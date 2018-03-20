#!/bin/bash

bootstrap=_impl_
st_dir=${ST_CODE:-${HOME}/spring-tips-code-test}
mkdir -p $st_dir
full_bootstrap=$st_dir/$bootstrap
echo $full_bootstrap
[[ -e $full_bootstrap ]] || git clone git@github.com:spring-tips/_impl_.git $full_bootstrap
$full_bootstrap/github/repos.rb