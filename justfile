alias ls := list

_listing:
	@just --list --no-aliases --unsorted \
		--list-heading=$'\e[34m{{justfile()}}\e[m\n' \
		--list-prefix=' • ' | sed -e 's/ • \[/[/'

# [ls] list installed *-lyderic packages
list:
	@pacman -Q | grep lyderic \
		| sed 's/-lyderic/\x1b[2m-lyderic\x1b[0m/' \
		| awk '{printf "• %-27s %s\n", $1, $2}'

# install packages needed on a workstation
install-workstation:
	just deploy balena-etcher dasel duckdb freetube kepubify koreader moar pandoc sqlpage 

# show package name and version
show $package:
	#!/bin/bash
	pkgbuild="${package}/PKGBUILD"
	name=$(awk -F= '/^pkgname=/ {print $2}' "${pkgbuild}")
	version=$(awk -F= '/^pkgver=/ {print $2}' "${pkgbuild}")
	echo -e "${name} v${version} "
	pacman -Q "${package}-lyderic" > /dev/null 2>&1 && {
		ok installed
	} || {
		warn not installed
	}

_get_packages:
	#!/bin/bash
	root="{{justfile_dir()}}"
	for path in $(find "${root}" -name PKGBUILD); do
		basename $(dirname "${path}")
	done

# build and install/update <packages>
deploy *$packages: _install_deps
	#!/bin/bash
	for package in ${packages} ; do
		blue "[${package}]"
		makepkg -D "${package}" -sic --needed
	done
@_install_deps:
	sudo pacman -S --needed --noconfirm fakeroot > /dev/null 2>&1

# update checksums in <package>
checksums $package:
	@cd "${package}" && updpkgsums

# remove everything in <package> except PKGBUILD
clean $package: (_check_is_package package)
	rm -rvf ${package}/{pkg,src} ${package}/*.{tar.gz,tgz,zip,gz,pkg.tar.zst}

# remove everything in all packages except PKGBUILD
clean-all:
	#!/bin/bash
	for package in $(ls -d */) ; do
		blue "[${package}]"
		just clean "${package}"
	done

# certain operation are dangerous and should only be run if the
# argument passed is actually a package and not some random dir
@_check_is_package $package:
	[ -d "${package}" ]
	[ $(dirname $(realpath "${package}")) == "{{justfile_dir()}}" ]
	[ -e "${package}/PKGBUILD" ]

set shell := ["bash","-uc"]
