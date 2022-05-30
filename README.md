[![CC-BY-NC-SA](https://licensebuttons.net/l/by-nc-sa/3.0/88x31.png)](LICENSE.md)
[![build-site](https://img.shields.io/github/workflow/status/2-alchemists/krossboard-docs/build%20site?label=build&style=for-the-badge)](https://github.com/2-alchemists/krossboard-docs/actions/workflows/build.yml)
[![deploy-site](https://img.shields.io/github/workflow/status/2-alchemists/krossboard-docs/deploy%20site?label=deploy&style=for-the-badge)](https://github.com/2-alchemists/krossboard-docs/actions/workflows/deploy.yml)
[![site](https://img.shields.io/badge/%F0%9F%8C%8E-site-blue?style=for-the-badge)](https://krossboard.app)

# Overview & License

This project holds the documentation website for [Krossboard](https://krossboard.app/).

This project is Open Sourced under the terms of the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (also known as CC-BY-NC-SA). See the [LICENSE](LICENSE.md) file for more details.

# Contributions

Contributions are welcomed for typos, misspellings, or inaccurate information in the documentation.

Each contribution should be submitted through a Github [pull request](https://github.com/2-alchemists/krossboard-docs/pulls). By submitting a contribution, you accept that it'll be published under the same terms of CC-BY-NC-SA License.

## Requirements

[Hugo](https://gohugo.io/) static site generator `v0.75.x` minimum (`v0.75.1` is the version currently used by the CI).

```
sudo snap install hugo --classic
```

## View the site in development mode

```sh
hugo server
```

Then open [http://localhost:1313/](http://localhost:1313/)

## Build a distribution

```sh
hugo --minify
```

The will compile the content and generate the static site in the folder `./public`.

## Deploy a distribution locally

The site can be deployed locally using a rudimentary web server to serve files in the `public/` directory with TLS enabled.

The following tools are used:

- [mkcert](https://github.com/FiloSottile/mkcert) - a simple tool for making locally-trusted development certificates.
- [ran](https://github.com/m3ng9i/ran) - a simple static web server (written in Go).

Steps are following:

- if not already done, generate a locally-trusted certificate:

```sh
mkcert my-machine.local
```

- start the web server:

```sh
cd public
ran -cert=../my-machine.local.pem -key=../my-machine.local-key.pem .
```

The site is then available at: [https://my-machine.local/](https://my-machine.local)
