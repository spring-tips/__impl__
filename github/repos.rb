#!/usr/bin/env ruby

if __FILE__ == $0
  root = $1 ? $1 : "#{ENV['HOME']}/Desktop/st-repo/repos.txt"
  File.new(root)
      .readlines
      .map {|line| line.strip}
      .select {|x| not Dir.exists?(x)}
      .map {|line| "git@github.com:spring-tips/#{line}.git"}
      .map {|x| "git clone #{ x }"}
      .each {|x| `#{x}`}
end