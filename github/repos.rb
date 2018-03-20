#!/usr/bin/env ruby


st=ENV["ST_CODE"]
expand_dir = st
repository_file = File.join(File.join(expand_dir, '_impl_/github'), 'repos.txt')


File.new(repository_file)
    .readlines
    .map(&:strip)
    .map {|line| {repo: line, dir: File.join(expand_dir, line)}}
    .reject {|x| Dir.exist?(x[:dir])}
    .map {|line| {repo: "git@github.com:spring-tips/#{line[:repo]}.git", dir: line[:dir]}}
    .map {|x| "git clone #{x[:repo]} #{x[:dir]} "}
    .each {|x| `#{x}`}
