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
