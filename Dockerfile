FROM alpine:latest

# Install required packages
RUN apk add --no-cache git curl jq openssh bash

# Create a directory for the script
RUN mkdir -p /app
WORKDIR /app

# Copy the bash script into the container
COPY backup /app/backup
RUN chmod +x /app/backup

# Copy the start script into the container and run it
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh
CMD /app/start.sh
