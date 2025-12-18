FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV PORT=8080

RUN apt update && apt install -y \
  xfce4 xfce4-goodies \
  xvfb x11vnc \
  novnc websockify \
  xterm openssl \
  curl wget git tzdata \
  && rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

EXPOSE 8080

CMD bash -ex << 'EOF'
# Start virtual X server
Xvfb :0 -screen 0 1024x768x16 &

# Start VNC server
x11vnc -display :0 -nopw -forever -shared &

# SSL cert
openssl req -new -x509 -days 365 -nodes \
  -subj "/C=JP" \
  -out /self.pem -keyout /self.pem

# Start noVNC (FOREGROUND)
websockify \
  --web=/usr/share/novnc/ \
  --cert=/self.pem \
  0.0.0.0:$PORT localhost:5900
EOF
