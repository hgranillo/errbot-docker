# kriev/errbot-alpine

[![](https://images.microbadger.com/badges/image/kriev/errbot-alpine.svg)](https://microbadger.com/images/kriev/errbot-alpine "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/kriev/errbot-alpine.svg)](https://microbadger.com/images/kriev/errbot-alpine "Get your own version badge on microbadger.com")

[![](https://images.microbadger.com/badges/image/kriev/errbot-alpine:python2.svg)](https://microbadger.com/images/kriev/errbot-alpine:python2 "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/kriev/errbot-alpine:python2.svg)](https://microbadger.com/images/kriev/errbot-alpine:python2 "Get your own version badge on microbadger.com")

Docker image for [Err](http://errbot.net), a chat-bot designed to be easily deployable, extensible and maintainable.

This image is based on the popular [Alpine Linux](alpinelinux.com) project, available in the [alpine official image](https://hub.docker.com/_/alpine/). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

## Usage

This container can be started in three different modes:

* ___shell:___ Start a bash session as the bot account (*err*).
* ___rootshell:___ Start a bash session as the root account.
* ___err:___ Start the bot itself. Any additional arguments passed here will be passed on to `err.py`.

For example, try: `docker run --rm -it kriev/errbot err --help`

To successfully run the bot, you will have to mount a [config.py](http://errbot.net/_downloads/config-template.py) into the `/err/` directory (`--volume` option to docker run).

Inside the container, `/err/data/` has already been set aside for data storage. You should mount this directory as a data volume as well in order to de-couple your bot data from the container itself.

```
docker run --rm -it -v /path/to/errbot/config.py:/err/config.py -v /path/to/errbot/data:/err/data errbotfix err
```

## Installing dependencies

Some plugins require additional dependencies that may not be installed in the virtualenv by default. There are three ways to deal with this, listed from best practice to worst:

1. Build your own image.
2. Let Err install dependencies automatically by setting `AUTOINSTALL_DEPS = True` in `config.py`.
3. Enter a running container manually (`docker exec --interactive --tty <container-name> shell` where `<container-name>` is the name listed by `docker ps`) and install with pip as in step 2 above (`runas err /err/virtualenv/bin/pip install somepkg`).


## Container layout

* `/err`: Home directory of the user account for Err. `config.py` is expected to go here.
* `/err/.ssh/`: The `.ssh` directory of the bot user (you can mount private SSH keys into this directory if you need to install plugins from private repositories).
* `/err/virtualenv/`: The virtualenv containing the Python interpreter and installed packages.
* `/err/data/`: A volume intended to store bot data (`BOT_DATA_DIR` setting of `config.py`).


## Security notes

* The bot is run under its own user account (*err*), not as root.
* SSH is set up to automatically add unknown host keys (*StrictHostKeyChecking no*).

## TO-DO:

* Review the storage volume settings
* Clean useless packages.

-----

### Credits

This is a modified version of https://github.com/zoni/docker-err to run on Alpine, with no support for Python2. Credit for the bash scripts goes to him.
