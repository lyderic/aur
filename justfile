_listing:
	@just --list --no-aliases --unsorted \
		--list-heading=$'\e[34m{{justfile()}}\e[m\n' \
		--list-prefix=' • ' | sed -e 's/ • \[/[/'

# build and install/update all *-lyderic packages
deploy:
	#!/bin/bash
	for dir in  */; do
		dir=$(basename "${dir}")
		printf "\e[45;93m %-32.32s\e[m\n" "${dir}"
		cd "${dir}"
		makepkg -sic --needed
		cd ..
	done

set shell := ["bash","-uc"]
