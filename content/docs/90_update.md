+++
title = "Update/Upgrade Guide"
description = ""
weight = 90
draft = false
bref = ""
toc = true
aliases = ["/docs/update/"]
+++

This guide describes how to update an instance of Krossboard towards a recent version.

It assumes that you already have a working Krossboard instance, regardless of your running environment (on cloud or on-premises).

## Update steps
Follow the next steps to update your instance of Krossboard.

* Go to the [release page](https://github.com/2-alchemists/krossboard/releases) and download the setup package of the targeted version.
* Copy the archive to the your Krossboard machine.
* Uncompress the archive, review the NOTICE and the EULA files if needed.
  ```sh
  tar zxf krossboard-<VERSION>.tgz
  cd krossboard-<VERSION>
  ```
* Use this command to launch the update.

  ```sh
  sudo ./update.sh
  ```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL (i.e. http://<machine-addr>/, changing `<machine-addr>` with the address of the instance).

Use the same username and password as on your previous version.

## Other resources
* [Discover and explore Krossboard analytics and data export]({{< relref "/docs/02_analytics-and-data-export" >}})