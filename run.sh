#!/bin/sh
docker build -t picture_frame .
docker run --name=picture_frame                 \
	   --restart=always                     \
	   -e "REFRESH_IN_MS=30000"             \
	   -d                                   \
	   -p 4000:4000                         \
	   -v /media/storage/Pictures:/pictures \
	   picture_frame
