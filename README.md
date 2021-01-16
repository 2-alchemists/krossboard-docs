[![CC-BY-NC-SA](https://licensebuttons.net/l/by-nc-sa/3.0/88x31.png)](LICENSE)
![build-site](https://github.com/2-alchemists/krossboard-docs/workflows/build%20site/badge.svg)
![deploy-site](https://github.com/2-alchemists/krossboard-docs/workflows/deploy%20site/badge.svg)
[![site](https://img.shields.io/badge/%F0%9F%8C%8E-site-blue?style=flat)](https://krossboard.app/)

# Overview & License
This project holds the documentation website for Krossboard.

This project is open sourced under the terms of the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (also known as CC-BY-NC-SA). See the [LICENSE](LICENSE.md) file for more details.

# Contributions
Contributions are welcomed for typos, misspellings, or inaccurate information in the documentation.

Each contribution should be submitted through a Github pull request. By submitting a contribution, you accept that it'll be published under the same terms of CC-BY-NC-SA License. 

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

