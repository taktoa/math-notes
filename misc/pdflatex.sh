#!/usr/bin/env bash
raw_args="$(echo "$@" | tr ' ' '\n')"
args="$(echo "$raw_args" | head -n -1 | tr '\n' ' ')"
raw_file="$(echo "$raw_args" | tail -n 1)"
file="$(basename $raw_file .org).tex"
current_dir="$(pwd)"
cd "$current_dir/.."; make pandoc; cd "$current_dir"
raw_command="pdflatex $args $file"
command="$(echo "$raw_command" | tr '\n' ' ')"
echo "$command"
echo "$command" | bash
