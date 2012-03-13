#!/bin/bash

RATE_DEFAULT=16000
if [ $# -lt 1 ]; then echo "Usage: $0 wav_dir [target rate in Hz]"; fi
if [ $# -lt 2 ]; then rate_out=$RATE_DEFAULT; else rate_out=$2; fi
dir=$1
dir_orig=$dir/orig_wavs
for f in $dir/*.wav; do
    rate=$(code/get_audio_data.sh $f | tail -n1 | sed 's/ID_AUDIO_RATE=//g')
    if [ $rate -ne $rate_out ]; then
        mkdir $dir_orig 2>/dev/null
        mv $f $dir_orig
        echo "resampling $(basename $f) from $rate to $rate_out Hz"
        sox $dir_orig/$(basename $f) $dir/$(basename $f) rate -h $rate_out
    fi
done
