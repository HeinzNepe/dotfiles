#!/usr/bin/env bash

sudo apt update
sudo install gum

export DEBIAN_FRONTEND=noninteractive

IFS=' ' read -r -a packages <<<"$common_packages"
IFS=' ' read -r -a pypacks <<<"$python_packages"

packages+=(
    python3
    python3-pip
    command-not-found
)

