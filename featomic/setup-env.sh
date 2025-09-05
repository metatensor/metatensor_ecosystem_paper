#!/usr/bin/env bash

set -eux

rm -rf virtualenv
python3.10 -m venv virtualenv

source ./virtualenv/bin/activate

pip install -U pip

pip install quippy-ase ase "numpy<2" skmatter featomic dscribe torch-spex metatensor-torch vesin-torch
pip install --index-url "file://$(pwd)/" rascal
