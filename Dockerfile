FROM ruby:2.4-onbuild

ENV PICTURES_PATH=/media/storage/Pictures
EXPOSE 4000

# docker run -p 4000:4000 -v /path/to/pictures:/pictures picture_frame
CMD ["./app.rb"]
