#!/bin/bash

ffprobe -i $1 -show_streams -select_streams a -loglevel error
