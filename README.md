# IsoTor

## Remote Tor browser

This container runs a web server that serves an actual Tor browser when you navigate to it. Under the hood, the container is running xRDP over Apache Guacamole to serve up the Tor browser window. The X session is locked into the Tor browser and will respawn the Tor browser if the window is closed.

![](foxception.png)

This project is a fork of my older project [foxception](https://github.com/lawndoc/foxception) that was originally inspired by [this blog post](http://ivo2u.nl/Yo) by IvoNet. 

This project is continuously evaluated for security vulnerabilities, but it also includes an added mitigation for zero-day exploitation. A seccomp whitelist filter is used that restricts the syscalls that the container can make to only what it needs to function. Even if exploitation should happen, the seccomp filter will greatly restrict what the container can do. This may prevent impact or even exploitation altogether depending on the situation.

## Installation / running the image

#### The quick and dirty way

This image is published on Docker Hub, and you can run it with the command:

`$ docker run -d --rm --shm-size=2G -p 8080:8080 --name IsoTor lawndoc/IsoTor:latest`

It is important to include all of the flags in order for this docker container to run and close properly. I recommend you read up on all of the flags being used and what they mean (see IMPORTANT NOTE below).

#### Running with Seccomp

You can run this image with a seccomp filter to minimize the permitted syscalls of the container in the event of successful exploitation. To do this, you clone this repo, build an image with the provided script, and run with the provided seccomp filter:

`$ git clone https://github.com/lawndoc/IsoTor.git`

`$ cd IsoTor`

`$ ./build.sh`

`$ sudo docker run -d --shm-size=2G -p 8080:8080 --security-opt seccomp=IsoTor_seccomp.json --name IsoTor lawndoc/IsoTor:latest`

The seccomp filter was made with [this tool](https://github.com/lawndoc/oci-seccomp-bpf-hook) which logs all syscalls made to the kernel and then generates a seccomp filter when you stop the container. The provided filter allows only the syscalls required for this container to function as it was intended. I highly recommend using the seccomp filter every time the container is run (see IMPORTANT NOTE below).

Also, keep in mind that if you fork this project for private use and modify the container too much it may require additional syscalls that are not whitelisted by the provided seccomp filter. In that scenario, you can use the tool mentioned above to generate a new filter.

## IMPORTANT NOTE:

Depending on your setup, this browser may be exposed to the internet. Since it is running on your network, anything that is done on the browser will be tied back to the host network. Therefore, make sure you know where it is accessible from and control access with firewalls, htpasswd, etc... For added security, you should always run this container with the provided seccomp filter as instructed above.
