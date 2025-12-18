FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  xfce4 xfce4-goodies \
  tigervnc-standalone-server \
  novnc websockify \
  xterm openssl \
  curl wget git tzdata \
  && rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

ENV PORT=8080
EXPOSE 8080

CMD bash -c '\
  vncserver -localhost no -SecurityTypes None -geometry 1024x768 && \
  openssl req -new -x509 -days 365 -nodes \
    -subj "/C=JP" \
    -out /self.pem -keyout /self.pem && \
  websockify --web=/usr/share/novnc/ \
    --cert=/self.pem \
    0.0.0.0:$PORT localhost:5901 \
'
