### Build the runner
1. Request a new runner token from GitHub
2. Put it into the .token file
3. Build the container
   ```bash
   docker build -t ga-runner --secret id=token,src=.token --build-arg REPO=https://github.com/r2rationality/turbojam .
   ```

### Start the runner
```bash
docker run --rm -it --cpus=2 --memory=2gb ga-runner
```