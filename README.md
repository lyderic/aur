# Lydéric's Own AUR

This repository contains Arch build files that download or build binary and packages, created by Lydéric.

All these packages are of the form _foo_-lyderic, so they are easily listable with:

```bash
$ pacman -Q | grep lyderic
```

They aim to replace binaries from the `upda` script.

# Building

To build package _foo_:

```bash
$ cd foo
$ makepkg -sic
```

To remove package _foo_:

```bash
$ sudo pacman -Rns foo
```

# justfile

The justfile provides a list of action (deploy, clean...) that can be performed on one package or **all** packages (`all` recipe). For example, to deploy package _foo_, run:

```bash
$ just deploy foo
```

To deploy or refresh all packages on a workstation

```bash
$ just install-workstation
```
