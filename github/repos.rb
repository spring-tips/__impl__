#!/usr/bin/env ruby

if $PROGRAM_NAME == __FILE__

  puts ENV["ST_HOME"]

  exit
  expand_dir = File.expand_path('../../..', $PROGRAM_NAME)
  repository_file = File.join(File.expand_path('..', $PROGRAM_NAME), 'repos.txt')
  File.new(repository_file)
      .readlines
      .map(&:strip)
      .map {|line| {repo: line, dir: File.join(expand_dir, line)}}
      .reject {|x| Dir.exist?(x[:dir])}
      .map {|line| {repo: "git@github.com:spring-tips/#{line[:repo]}.git", dir: line[:dir]}}
      .map {|x| "git clone #{x[:repo]} #{x[:dir]} "}
      .each {|x| `#{x}`}
end
