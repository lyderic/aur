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

# install the packages needed on a workstation
install-workstation:
	#!/bin/bash
	for package in \
		dasel duckdb emd freetube kepubify koreader moar pandoc sqlpage; do
		printf "\e[45;93m %-32.32s\e[m\n" "${package}"
		just deploy "${package}"
	done

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

# build and install/update <package>
deploy $package:
	@makepkg -D "${package}" -sic --needed

# update checksums in <package>
checksums $package:
	@cd "${package}" && updpkgsums

# remove everything in <package> except PKGBUILD
clean $package: (_check_is_package package)
	@find "${package}" -type f ! -name 'PKGBUILD' -exec rm -v "{}" \;

# certain operation are dangerous and should only be run if the
# argument passed is actually a package and not some random dir
@_check_is_package $package:
	[ -d "${package}" ]
	[ $(dirname $(realpath "${package}")) == "{{justfile_dir()}}" ]
	[ -e "${package}/PKGBUILD" ]

set shell := ["bash","-uc"]
