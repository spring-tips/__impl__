#!/bin/bash


if [ -z "$INPUT_ASSETS"]
then
  echo "you must provide an \$INPUT_ASSETS environment variable pointing to a directory in which we can find:"
  echo " intro.mov"
  echo " outro.mov"
  echo " cnj.mov"
  exit 1
fi

if [ -z "$1" ]
then
  echo "Spring Tips Producer"
  echo "use: convert.sh my-screen-recording.ogv"
  echo "(no input recording given.)"
  exit 1
else
  echo "creating Spring Tip video for file '$1'."
fi

movie=$1

in=$(
  echo $INPUT_ASSETS
  mkdir -p in
  cd in
  cp $INPUT_ASSETS/intro.mov .
  cp $INPUT_ASSETS/outro.mov .
  cp $INPUT_ASSETS/cnj.mov .
  pwd
  cd ..
)

out=$(
  rm -rf out
  mkdir -p out
  cd out
  pwd
  cd ..
);


function detect_audio(){
  ffprobe -i $1 -show_streams -select_streams a -loglevel error
}

function add_audio_track(){
  ffmpeg -ar 44100 -acodec pcm_s16le -f s16le -ac 2 -channel_layout 2.1 \
       -i /dev/zero -i $1 -vcodec copy -acodec  aac -shortest $2
}

# the 3 bumpers don't have a sound track, so add them here
add_audio_track in/intro.mov out/intro-audio.mov
add_audio_track in/outro.mov out/outro-audio.mov
add_audio_track in/cnj.mov out/cnj-audio.mov

ffmpeg -i $movie   -vf "scale=1920:1080,setsar=1"  out/MOVIE.mov

ffmpeg -i out/intro-audio.mov -i out/cnj-audio.mov -i out/MOVIE.mov -i out/outro-audio.mov  \
 -filter_complex "[0:v:0] [0:a:0] [1:v:0] [1:a:0] [2:v:0] [2:a:0] [3:v:0] [3:a:0]  concat=n=4:v=1:a=1 [v] [a]" \
 -map "[v]" -map "[a]"  out/RESULT.mov

mv out/RESULT.mov .
rm -rf out 
