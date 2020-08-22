# Krossboard documentation

![build-site](https://github.com/2-alchemists/krossboard-docs/workflows/build%20site/badge.svg)
![deploy-site](https://github.com/2-alchemists/krossboard-docs/workflows/deploy%20site/badge.svg)
[![site](https://img.shields.io/badge/%F0%9F%8C%8E-site-blue?style=flat)](https://krossboard.app/)

> Documentation site for Krossboard product.

## Requirements

[Hugo](https://gohugo.io/) static site generator `v0.74.x` minimum (`v0.74.2` is the version currently used by the CI).

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