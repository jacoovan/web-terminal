FROM busybox:1.35.0

WORKDIR /app
COPY config config
COPY web-terminal web-terminal
EXPOSE 80 8081
CMD ["/app/web-terminal"]