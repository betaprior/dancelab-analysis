#!/bin/bash

for fn_in in "$@"; do
    fn_out=$(sed -e 's|\.3gp$||g' -e 's|$|.wav|g' <<< $fn_in)
    ffmpeg -i $fn_in -vn -f wav -acodec pcm_u8 $fn_out
done
