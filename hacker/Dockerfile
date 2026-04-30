FROM alpine:latest
RUN apk add --no-cache curl bash mitmproxy
COPY ./start.sh .
RUN chmod +x start.sh
COPY ./welcome.sh /etc/welcome.sh
RUN chmod +x /etc/welcome.sh
RUN echo "source /etc/welcome.sh" >> /root/.bashrc
CMD ["bash", "start.sh"]
