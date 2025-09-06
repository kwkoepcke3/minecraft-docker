git clone https://github.com/Tiiffi/mcrcon.git mcrcon

sendmail/.env:
PASSWORD=google app password
IPV4=minecraft server ip
EMAIL=google email account

sudo podman run -p 25565:25565 -p 25575:25575 -v /home/minecraft/hasturian:/opt/minecraft/run/minecraft -v /opt/minecraft/backups:/opt/minecraft/backups minecraft-image:latest
