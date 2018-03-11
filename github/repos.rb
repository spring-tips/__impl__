#!/usr/bin/env ruby

if __FILE__ == $0

  expand_dir = File.expand_path('../../..', $0)

  repository_file = File.join(File.expand_path('..', $0), 'repos.txt')

  File.new(repository_file)
      .readlines
      .map {|x| x.strip}
      .map {|line| {:repo => line, :dir => File.join(expand_dir, line)}}
      .select {|x| not Dir.exists?(x[:dir])}
      .map {|line| {:repo => "git@github.com:spring-tips/#{ line[:repo] }.git", :dir => line[:dir]}}
      .map {|x| "git clone #{ x[:repo] } #{ x[:dir] } "}
      .each {|x| `#{x}`}
end