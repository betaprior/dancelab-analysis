#!/bin/bash

mplayer -identify -frames 0 $1 | grep LENGTH\\\|RATE
