# Assignment 5: Docker Hello World Applications

Six Hello World web applications, each in its own folder with its own Dockerfile.
Each one is built into an image, run as a container, and checked with curl.

## nginx-app

### Dockerfile

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

### Build command

```
cd nginx-app
docker build --no-cache -t nginx-hello .
```

Output:

```
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 114B 0.0s done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/nginx:alpine
#2 DONE 0.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 31B done
#4 DONE 0.0s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:a9ae6f6d078d477e21323310498e5196cb2b7c0aedd9e07b7306612077227d7c
#5 resolve docker.io/library/nginx:alpine@sha256:a9ae6f6d078d477e21323310498e5196cb2b7c0aedd9e07b7306612077227d7c 0.0s done
#5 CACHED

#6 [2/2] COPY index.html /usr/share/nginx/html/index.html
#6 DONE 0.0s

#7 exporting to image
#7 exporting layers 0.1s done
#7 exporting manifest sha256:964d3239c637b6474e3313d8585791128f5a1c87166e0a2d40a93a35a8331754 done
#7 exporting config sha256:fee4d4556fb319e585258fc8ab4564d5426f796d072442d21a2ae5574cdc27f5 done
#7 exporting attestation manifest sha256:2198871f20caf1e6cdc8cec66b315d4162022ab37dfaebbbcf4c9efe3b7e6ba3 0.0s done
#7 exporting manifest list sha256:8faa81f54c61534d05ef174f468c62bf4374338ddc1344a8210d0e4ebffa442e done
#7 naming to docker.io/library/nginx-hello:latest done
#7 unpacking to docker.io/library/nginx-hello:latest 0.0s done
#7 DONE 0.2s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/yx1dmdv5ji9ry3gmc1de2xib4
```

### Run command

```
docker run -d --name nginx-hello -p 8081:80 nginx-hello
```

Output:

```
7e0f0582b1338be7952ed04e1e6d64b54c4700dfae1065a7ffca0bf29e6adb73
```

### Curl output

```
$ curl http://localhost:8081
<!DOCTYPE html>
<html>
<head>
  <title>Hello World</title>
</head>
<body>
  <h1>Hello World from Nginx</h1>
</body>
</html>
```

### What this Dockerfile does

This Dockerfile starts from the official nginx:alpine image, which already has a web server set up. It copies index.html into /usr/share/nginx/html, the folder nginx serves by default. Nginx starts on its own, so no CMD line is needed.

## Apache-app

### Dockerfile

```dockerfile
FROM httpd:2.4
COPY index.html /usr/local/apache2/htdocs/index.html
EXPOSE 80
```

### Build command

```
cd Apache-app
docker build --no-cache -t apache-hello .
```

Output:

```
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 115B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/httpd:2.4
#2 DONE 0.1s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 31B done
#4 DONE 0.0s

#5 [1/2] FROM docker.io/library/httpd:2.4@sha256:979c38c2228d28c2edfd45c6e27dcee1c7b4a101a5526721ae8ece454e89e99e
#5 resolve docker.io/library/httpd:2.4@sha256:979c38c2228d28c2edfd45c6e27dcee1c7b4a101a5526721ae8ece454e89e99e 0.0s done
#5 CACHED

#6 [2/2] COPY index.html /usr/local/apache2/htdocs/index.html
#6 DONE 0.1s

#7 exporting to image
#7 exporting layers 0.1s done
#7 exporting manifest sha256:a7d35dab2b4ee32a0e7000e84949f0be3d05c4ce3f364fbc051352cd69de298c 0.0s done
#7 exporting config sha256:b2fede12bdf0b1739fe9c9b7ebaf242b5a610ce1f2e4fcc258bcf9bf40521323 0.1s done
#7 exporting attestation manifest sha256:408224bf5cfcbd0a9cf3cf6acd5a3c8577848cecbe7da4329e0625ca182de3e2 0.0s done
#7 exporting manifest list sha256:a123114f34cba66930cbf06f718af0c2fd90ae846fc62c0723ab37caf3f809c2
#7 exporting manifest list sha256:a123114f34cba66930cbf06f718af0c2fd90ae846fc62c0723ab37caf3f809c2 0.0s done
#7 naming to docker.io/library/apache-hello:latest done
#7 unpacking to docker.io/library/apache-hello:latest 0.0s done
#7 DONE 0.3s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/um5m10qpuybxp0j8mplqklw9l
```

### Run command

```
docker run -d --name apache-hello -p 8082:80 apache-hello
```

Output:

```
11ca7b95d1e73e7d14f5119df2cfc1acc715d181daf0597a2de5354526c8596e
```

### Curl output

```
$ curl http://localhost:8082
<!DOCTYPE html>
<html>
<head>
  <title>Hello World</title>
</head>
<body>
  <h1>Hello World from Apache</h1>
</body>
</html>
```

### What this Dockerfile does

This Dockerfile starts from the official httpd:2.4 image, which is the Apache web server. It copies index.html into /usr/local/apache2/htdocs, the folder Apache serves by default. The base image already starts Apache, so nothing else is needed.

## python-app

### Dockerfile

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

### Build command

```
cd python-app
docker build --no-cache -t python-hello .
```

Output:

```
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 200B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/python:3.12-slim
#2 DONE 0.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 63B done
#4 DONE 0.0s

#5 [1/5] FROM docker.io/library/python:3.12-slim@sha256:78387bc3881b8273120a12ebe6c1ab22b018ccc2c9adf565ae1ac9b536e184ea
#5 resolve docker.io/library/python:3.12-slim@sha256:78387bc3881b8273120a12ebe6c1ab22b018ccc2c9adf565ae1ac9b536e184ea
#5 resolve docker.io/library/python:3.12-slim@sha256:78387bc3881b8273120a12ebe6c1ab22b018ccc2c9adf565ae1ac9b536e184ea 0.0s done
#5 DONE 0.0s

#6 [2/5] WORKDIR /app
#6 CACHED

#7 [3/5] COPY requirements.txt .
#7 DONE 0.0s

#8 [4/5] RUN pip install --no-cache-dir -r requirements.txt
#8 2.336 Collecting flask==3.0.3 (from -r requirements.txt (line 1))
#8 3.471   Downloading flask-3.0.3-py3-none-any.whl.metadata (3.2 kB)
#8 3.500 Collecting Werkzeug>=3.0.0 (from flask==3.0.3->-r requirements.txt (line 1))
#8 3.529   Downloading werkzeug-3.1.8-py3-none-any.whl.metadata (4.0 kB)
#8 3.555 Collecting Jinja2>=3.1.2 (from flask==3.0.3->-r requirements.txt (line 1))
#8 3.563   Downloading jinja2-3.1.6-py3-none-any.whl.metadata (2.9 kB)
#8 3.579 Collecting itsdangerous>=2.1.2 (from flask==3.0.3->-r requirements.txt (line 1))
#8 3.587   Downloading itsdangerous-2.2.0-py3-none-any.whl.metadata (1.9 kB)
#8 3.607 Collecting click>=8.1.3 (from flask==3.0.3->-r requirements.txt (line 1))
#8 3.615   Downloading click-8.5.0-py3-none-any.whl.metadata (2.6 kB)
#8 3.628 Collecting blinker>=1.6.2 (from flask==3.0.3->-r requirements.txt (line 1))
#8 3.635   Downloading blinker-1.9.0-py3-none-any.whl.metadata (1.6 kB)
#8 3.689 Collecting MarkupSafe>=2.0 (from Jinja2>=3.1.2->flask==3.0.3->-r requirements.txt (line 1))
#8 3.707   Downloading markupsafe-3.0.3-cp312-cp312-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl.metadata (2.7 kB)
#8 3.718 Downloading flask-3.0.3-py3-none-any.whl (101 kB)
#8 3.742 Downloading blinker-1.9.0-py3-none-any.whl (8.5 kB)
#8 3.748 Downloading click-8.5.0-py3-none-any.whl (125 kB)
#8 3.768 Downloading itsdangerous-2.2.0-py3-none-any.whl (16 kB)
#8 3.776 Downloading jinja2-3.1.6-py3-none-any.whl (134 kB)
#8 3.797 Downloading werkzeug-3.1.8-py3-none-any.whl (226 kB)
#8 3.828 Downloading markupsafe-3.0.3-cp312-cp312-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl (24 kB)
#8 3.845 Installing collected packages: MarkupSafe, itsdangerous, click, blinker, Werkzeug, Jinja2, flask
#8 4.375 Successfully installed Jinja2-3.1.6 MarkupSafe-3.0.3 Werkzeug-3.1.8 blinker-1.9.0 click-8.5.0 flask-3.0.3 itsdangerous-2.2.0
#8 4.375 WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager, possibly rendering your system unusable. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv. Use the --root-user-action option if you know what you are doing and want to suppress this warning.
#8 4.476 
#8 4.476 [notice] A new release of pip is available: 25.0.1 -> 26.2.1
#8 4.476 [notice] To update, run: pip install --upgrade pip
#8 DONE 4.6s

#9 [5/5] COPY app.py .
#9 DONE 0.0s

#10 exporting to image
#10 exporting layers
#10 exporting layers 0.7s done
#10 exporting manifest sha256:3b1c4fa377e0a172494199162824f7fd343e4eeb72e542a07408abb153108881 done
#10 exporting config sha256:523ee4a41c1ee416effba1c0fb4170c22d0ed5b52bb0d3a2182534d3038cf7b4 done
#10 exporting attestation manifest sha256:a148a42efc95819f57d3a8ffa2183fd6df8b784b1514713f550e41db8aa61834 done
#10 exporting manifest list sha256:e7f8b2d1070465c542adbce56036e9cb91e95eb544e99de6b6e6db4fc971087a done
#10 naming to docker.io/library/python-hello:latest done
#10 unpacking to docker.io/library/python-hello:latest
#10 unpacking to docker.io/library/python-hello:latest 0.2s done
#10 DONE 1.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/nnz4d87v1istuogogbxz1htdq
```

### Run command

```
docker run -d --name python-hello -p 5001:5000 python-hello
```

Output:

```
7d45a38fa285265196f234a5860ace83bb7d057da191872c69fa9d0e548b7c71
```

### Curl output

```
$ curl http://localhost:5001
<h1>Hello World from Python</h1>```

### What this Dockerfile does

This Dockerfile starts from python:3.12-slim and sets /app as the working folder. It copies requirements.txt first and installs Flask, so that layer stays cached when only the app code changes. It then copies app.py and runs it with python, which starts the Flask server on port 5000.

## nodejs-app

### Dockerfile

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package.json .
COPY app.js .
EXPOSE 3000
CMD ["node", "app.js"]
```

### Build command

```
cd nodejs-app
docker build --no-cache -t node-hello .
```

Output:

```
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 139B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/node:20-alpine
#2 DONE 0.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 59B done
#4 DONE 0.0s

#5 [1/4] FROM docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293
#5 resolve docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293 0.0s done
#5 DONE 0.0s

#6 [2/4] WORKDIR /app
#6 CACHED

#7 [3/4] COPY package.json .
#7 DONE 0.0s

#8 [4/4] COPY app.js .
#8 DONE 0.0s

#9 exporting to image
#9 exporting layers 0.1s done
#9 exporting manifest sha256:3b4f5eaeea2fa1ae950ba173cc43021f45bcd37671d5ada2789c4fb63d3d66f2 done
#9 exporting config sha256:154adae17c49aeab93731ab3358bd3567e8eacd9e9c3e514f29e51da29da5353 done
#9 exporting attestation manifest sha256:93ee24301b8c002b84509060706c5a749e2b94cef582652a3026e21d1a579c52
#9 exporting attestation manifest sha256:93ee24301b8c002b84509060706c5a749e2b94cef582652a3026e21d1a579c52 0.0s done
#9 exporting manifest list sha256:77a18fe3455472e2cd29b9a4fde4bf09a2383c079837c36af98d97d56f4c289e 0.0s done
#9 naming to docker.io/library/node-hello:latest done
#9 unpacking to docker.io/library/node-hello:latest 0.0s done
#9 DONE 0.2s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/ug0h61fln3f0fwt3vlb57qy4w
```

### Run command

```
docker run -d --name node-hello -p 3001:3000 node-hello
```

Output:

```
5a8ca3567db4de4133024d604a72da71c98ee654b283941a4dfdad8a2d479ab9
```

### Curl output

```
$ curl http://localhost:3001
<h1>Hello World from Node.js</h1>```

### What this Dockerfile does

This Dockerfile starts from node:20-alpine and sets /app as the working folder. It copies package.json and app.js into the image. The app uses only the built in http module, so no npm install is needed, and CMD runs the server on port 3000.

## java-app

### Dockerfile

```dockerfile
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY HelloWorld.java .
RUN javac HelloWorld.java
EXPOSE 8080
CMD ["java", "HelloWorld"]
```

### Build command

```
cd java-app
docker build --no-cache -t java-hello .
```

Output:

```
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 168B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/eclipse-temurin:21-jdk
#2 DONE 0.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [1/4] FROM docker.io/library/eclipse-temurin:21-jdk@sha256:85f00967bcc624fc19fa9c2cf124ea426a5363898e267141726f31f358c2e14b
#4 resolve docker.io/library/eclipse-temurin:21-jdk@sha256:85f00967bcc624fc19fa9c2cf124ea426a5363898e267141726f31f358c2e14b 0.0s done
#4 DONE 0.0s

#5 [2/4] WORKDIR /app
#5 CACHED

#6 [internal] load build context
#6 transferring context: 37B done
#6 DONE 0.0s

#7 [3/4] COPY HelloWorld.java .
#7 DONE 0.0s

#8 [4/4] RUN javac HelloWorld.java
#8 DONE 1.1s

#9 exporting to image
#9 exporting layers 0.1s done
#9 exporting manifest sha256:9a60c572d2409cf4677d43ab33326cf96466f5f6ad841c957cea3d5b40402a9e
#9 exporting manifest sha256:9a60c572d2409cf4677d43ab33326cf96466f5f6ad841c957cea3d5b40402a9e 0.0s done
#9 exporting config sha256:b754b8cf1e58ae32e69d8c03192546ed3450d8bc4003953aad5280657c568cb7 done
#9 exporting attestation manifest sha256:116d158ed2b06130d6fad1d94809e4ae2d03fea81c74d43455db7f449b34205b 0.0s done
#9 exporting manifest list sha256:4319fb212741b53c78c6e387470da19c1939af57953aff2138798f200bf4a4e6 done
#9 naming to docker.io/library/java-hello:latest done
#9 unpacking to docker.io/library/java-hello:latest 0.0s done
#9 DONE 0.2s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/no1o0zhiadoygojyl9cdoliwq
```

### Run command

```
docker run -d --name java-hello -p 8083:8080 java-hello
```

Output:

```
25e76506643e26c883c30367f2704bc20217b60d531bcbeeb39b73c41a792c74
```

### Curl output

```
$ curl http://localhost:8083
<h1>Hello World from Java</h1>```

### What this Dockerfile does

This Dockerfile starts from eclipse-temurin:21-jdk, which includes the Java compiler and runtime. It copies HelloWorld.java into /app and compiles it with javac during the build. CMD then runs the compiled class, which starts a small HTTP server on port 8080.

## React-app

### Dockerfile

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
```

### Build command

```
cd React-app
docker build --no-cache -t react-hello .
```

Output:

```
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 223B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/node:20-alpine
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/nginx:alpine
#3 DONE 0.0s

#4 [internal] load .dockerignore
#4 transferring context: 58B done
#4 DONE 0.0s

#5 [build 1/6] FROM docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293
#5 resolve docker.io/library/node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293 0.0s done
#5 DONE 0.0s

#6 [build 2/6] WORKDIR /app
#6 CACHED

#7 [stage-1 1/2] FROM docker.io/library/nginx:alpine@sha256:a9ae6f6d078d477e21323310498e5196cb2b7c0aedd9e07b7306612077227d7c
#7 resolve docker.io/library/nginx:alpine@sha256:a9ae6f6d078d477e21323310498e5196cb2b7c0aedd9e07b7306612077227d7c 0.0s done
#7 CACHED

#8 [internal] load build context
#8 transferring context: 245B done
#8 DONE 0.0s

#9 [build 3/6] COPY package.json .
#9 DONE 0.0s

#10 [build 4/6] RUN npm install
#10 16.16 
#10 16.16 added 62 packages, and audited 63 packages in 16s
#10 16.16 
#10 16.16 7 packages are looking for funding
#10 16.16   run `npm fund` for details
#10 16.17 
#10 16.17 2 vulnerabilities (1 moderate, 1 high)
#10 16.17 
#10 16.17 To address all issues (including breaking changes), run:
#10 16.17   npm audit fix --force
#10 16.17 
#10 16.17 Run `npm audit` for details.
#10 16.18 npm notice
#10 16.18 npm notice New major version of npm available! 10.8.2 -> 12.0.2
#10 16.18 npm notice Changelog: https://github.com/npm/cli/releases/tag/v12.0.2
#10 16.18 npm notice To update run: npm install -g npm@12.0.2
#10 16.18 npm notice
#10 DONE 16.3s

#11 [build 5/6] COPY . .
#11 DONE 0.1s

#12 [build 6/6] RUN npm run build
#12 0.305 
#12 0.305 > react-app@1.0.0 build
#12 0.305 > vite build
#12 0.305 
#12 0.515 [33mThe CJS build of Vite's Node API is deprecated. See https://vite.dev/guide/troubleshooting.html#vite-cjs-node-api-deprecated for more details.[39m
#12 0.585 vite v5.4.21 building for production...
#12 0.645 transforming...
#12 1.461 ✓ 30 modules transformed.
#12 1.571 rendering chunks...
#12 1.578 computing gzip size...
#12 1.584 dist/index.html                  0.19 kB │ gzip:  0.16 kB
#12 1.584 dist/assets/index-DnZR9tUp.js  142.52 kB │ gzip: 45.74 kB
#12 1.585 ✓ built in 970ms
#12 DONE 1.6s

#13 [stage-1 2/2] COPY --from=build /app/dist /usr/share/nginx/html
#13 DONE 0.0s

#14 exporting to image
#14 exporting layers 0.0s done
#14 exporting manifest sha256:36a697d4365a8b03de205370bace8a10c9699f3199490a7e7c125d707eaebc18 done
#14 exporting config sha256:e36beea7ebe9d4354660d0897e3abac40d9d6c3742c63ea6d75976ad87ee5b77 done
#14 exporting attestation manifest sha256:b3202001da7b2bfa1e56e3573ba8ef42e2f7cc426a77a4fa2261636ebd89754b done
#14 exporting manifest list sha256:198830c4ae044f58f67af16168103b43958f0ddf96c604adf51d07dac774cc0c done
#14 naming to docker.io/library/react-hello:latest done
#14 unpacking to docker.io/library/react-hello:latest 0.0s done
#14 DONE 0.1s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/rj4cz1x4crvafy5spd9ioggch
```

### Run command

```
docker run -d --name react-hello -p 3002:80 react-hello
```

Output:

```
2a56ced18cbf9406b4cb78b672fc6c07d0b39bf8c58f0a17fb8d7d154bba4b4c
```

### Curl output

```
$ curl http://localhost:3002
<!DOCTYPE html>
<html>
<head>
  <title>Hello World</title>
  <script type="module" crossorigin src="/assets/index-DnZR9tUp.js"></script>
</head>
<body>
  <div id="root"></div>
</body>
</html>
```

### What this Dockerfile does

This is a two stage build. The first stage uses node:20-alpine to install the dependencies and run the Vite build, which turns the React code into plain HTML and JavaScript in a dist folder. The second stage starts from nginx:alpine and copies only that dist folder in, so the final image serves the built files and does not carry Node or node_modules.

React renders the page in the browser, so curl on the root URL returns the HTML shell.
The Hello World text lives in the JavaScript bundle that the shell loads. Fetching that bundle shows it:

```
$ curl -s http://localhost:3002/assets/index-DnZR9tUp.js | grep -o 'Hello World from React'
Hello World from React
```

## All containers running

```
$ docker ps
CONTAINER ID   IMAGE                                                   COMMAND                  CREATED         STATUS         PORTS                                                NAMES
2a56ced18cbf   react-hello                                             "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   0.0.0.0:3002->80/tcp, [::]:3002->80/tcp              react-hello
25e76506643e   java-hello                                              "/__cacert_entrypoin…"   6 seconds ago   Up 6 seconds   0.0.0.0:8083->8080/tcp, [::]:8083->8080/tcp          java-hello
5a8ca3567db4   node-hello                                              "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   0.0.0.0:3001->3000/tcp, [::]:3001->3000/tcp          node-hello
7d45a38fa285   python-hello                                            "python app.py"          7 seconds ago   Up 7 seconds   0.0.0.0:5001->5000/tcp, [::]:5001->5000/tcp          python-hello
11ca7b95d1e7   apache-hello                                            "httpd-foreground"       8 seconds ago   Up 7 seconds   0.0.0.0:8082->80/tcp, [::]:8082->80/tcp              apache-hello
7e0f0582b133   nginx-hello                                             "/docker-entrypoint.…"   8 seconds ago   Up 8 seconds   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp              nginx-hello
71dff0d003e5   docker.elastic.co/elasticsearch/elasticsearch:7.17.28   "/bin/tini -- /usr/l…"   5 months ago    Up 4 hours     127.0.0.1:9200->9200/tcp, 127.0.0.1:9300->9300/tcp   cdlidev_elasticsearch_1
```
