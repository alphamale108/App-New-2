FROM sailvessel/ubuntu:latest
WORKDIR /app

# Copy everything from the repo into /app
COPY . .

# Install dependencies + ntpdate
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      python3 \
      python3-pip \
      python3-dev \
      python3-venv \
      ffmpeg \
      aria2 \
      wget \
      curl \
      ntpdate \
    && rm -rf /var/lib/apt/lists/*

# Install appxdl from the repo root
# (Assumes "appxdl" is already in the same directory as Dockerfile)
RUN chmod +x /app/appxdl && \
    mv /app/appxdl /usr/local/bin/appxdl

# Install yt-dlp
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    -o /usr/local/bin/yt-dlp && chmod +x /usr/local/bin/yt-dlp

# Python venv + requirements
RUN python3 -m venv /venv && /venv/bin/pip install --no-cache-dir -r requirements.txt

ENV PATH="/usr/local/bin:/venv/bin:$PATH"
ENV API_ID="26909380"
ENV API_HASH="498821722f7fa36cda9600e039a3640c"
ENV BOT_TOKEN="7239301864"
ENV ALLOWED_USER_IDS="6873273483,7310262552"

# Sync time then start the bot
CMD gunicorn app:app & python3 main.py
