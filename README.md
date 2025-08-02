### Build the runner
1. Request a new runner token from GitHub
2. Put it into the .token file
3. Build the container
   ```bash
   docker build -t ga-runner --secret id=token,src=.token --build-arg REPO=https://github.com/r2rationality/turbojam .
   ```

### Start the runner
```bash
docker run -v //var/run/docker.sock:/var/run/docker.sock -it --cpus=2 --memory=2gb ga-runner
```

Notes:
- running the container without --rm flag insures that the runner's data is kept between restarts