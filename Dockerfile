FROM ruby:2.4-onbuild

# Mount picture directory to /pictures
ENV PICTURES_PATH=/pictures
EXPOSE 4000

# docker run -p 4000:4000 -v /path/to/pictures:/pictures picture_frame
CMD ["./app.rb"]
