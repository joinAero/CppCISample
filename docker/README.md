# CppCISample Docker Image

## Build

```bash
cd docker/
docker build -t cppcisample:v1 .
```

## Run

```bash
docker run -it cppcisample:v1 /bin/bash

ls /usr/src/CppCISample/
ls /usr/local/bin | grep demo
```
