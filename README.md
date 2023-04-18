# git-backup

[![](https://img.shields.io/badge/-github-black.svg?logo=github)](https://github.com/vchrombie/git-backup)
[![](https://img.shields.io/badge/dockerhub-lightblue.svg?logo=docker)](https://hub.docker.com/r/vchrombie/git-backup)

This repository contains a bash script for a sidecar container that automatically backs up a specified directory to a GitHub repository. The backup process runs periodically using a cron job and can be configured to meet your specific requirements.

## Features

- Easy-to-use & configurable backup process
- Automatically backs up specified files/directories to a GitHub repository
- Periodic backup using a cron job
- Pre-backup script execution support
- Configurable Git commit messages
- Configurable git user name and email

## Usage

1. Clone this repository
```bash
git clone https://github.com/vchrombie/git-backup
cd git-backup
```
2. Copy the `.env.example` file to `.env` and set the required environment variables
```bash
cp .env.example .env
```
3. Build the Docker image using the provided [`Dockerfile`](Dockerfile)
```bash
docker build -t git-backup .
```
4. Run the Docker container with the required environment variables (replace the placeholder values with your own)
```bash
docker run -d \
  --name git-backup \
  --restart unless-stopped \
  -e GITHUB_REPO="username/repository" \
  -e GITHUB_BRANCH="backup-branch" \
  -e GIT_USER_NAME="Your Name" \
  -e GIT_USER_EMAIL="your.email@example.com" \
  -e GIT_SRC="/path/to/your/source/folder" \
  -e GITHUB_USERNAME="your-github-username" \
  -e GITHUB_ACCESS_TOKEN="your-github-password-or-token" \
  -e FILES_TO_COMMIT="file1 file2 /path/to/folder" \
  -e COMMIT_MSG="Backup commit message" \
  -e PRE_BACKUP_SCRIPT="your pre-backup script 1; your pre-backup script 2" \
  -e BACKUP_FREQUENCY="* * * * *" \
  -v /path/to/your/source/folder:/data \
  git-backup
```
5. You can use to run the container using Docker Compose too. Set the required environment variables in the [`docker-compose.yml`](docker-compose.yml) file
```yml
version: '3.7'
services:
  nodered:
    image: nodered/node-red:latest
    volumes:
      - ./data/nodered:/data
    ports:
      - '1880:1880'
    restart: always

  backup:
    image: git-backup
    environment:
      GITHUB_REPO: "vchrombie/floodnet-nodered"
      GITHUB_BRANCH: "nodered-backup"
      GIT_USER_NAME: "github-actions[bot]"
      GIT_USER_EMAIL: "github-actions[bot]@users.noreply.github.com"
      GIT_SRC: "/data/nodered"
      GITHUB_USERNAME: $GITHUB_USERNAME
      GITHUB_ACCESS_TOKEN: $GITHUB_ACCESS_TOKEN
      FILES_TO_COMMIT: >
        lib/
        flows.json
        .flows.json.backup
        .config.nodes.json
      COMMIT_MSG: "Backup nodered"
      PRE_BACKUP_SCRIPT: >
        echo 'This is a pre-backup script';
        echo 'This is another pre-backup script';
      BACKUP_FREQUENCY: "0 5 * * *"
    volumes:
      - ./data:/data
    restart: unless-stopped

volumes:
  nodered_backup:
    driver: local
```
6. Run the containers using Docker Compose
```bash
docker-compose up -d
```

## Configuration

The following environment variables can be set in the `docker-compose.yml` file to configure the backup process:

- `GITHUB_REPO`: The Git repository where the backups should be pushed (e.g., "username/repo").
- `GITHUB_BRANCH`: The branch in the Git repository where the backups should be pushed. (default: `main`)
- `GIT_USER_NAME`: The Git user name for committing changes. (default: `github-actions[bot]`)
- `GIT_USER_EMAIL`: The Git user email for committing changes. (default: `github-actions[bot]@users.noreply.github.com`)
- `GIT_SRC`: The source directory containing the files to be backed up. (default: `/src`)
- `GITHUB_USERNAME`: The GitHub username for authentication.
- `GITHUB_ACCESS_TOKEN`: The GitHub password or personal access token for authentication.
- `FILES_TO_COMMIT`: The list of files or directories to be included in the backup commit. (default: `.` - all files and directories)
- `COMMIT_MSG`: The commit message for the backup process. (default: `Backup on $TIMESTAMP`)
- `PRE_BACKUP_SCRIPT`: A script to be executed before the backup process starts. (default: `""` - no scripts)
- `BACKUP_FREQUENCY`: The frequency at which the backup process should run, specified as a cron expression. (default: `0 5 * * *` - every day at 5 AM)

## Credits

The initial work for this project was done by [@beasteers](https://github.com/beasteers) in the [FloodNet project](https://github.com/floodnet-nyc).
