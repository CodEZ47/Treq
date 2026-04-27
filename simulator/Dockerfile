FROM alpine:latest
RUN apk add --no-cache curl bash
COPY simulate.sh .
RUN chmod +x simulate.sh
CMD ["bash", "simulate.sh"]