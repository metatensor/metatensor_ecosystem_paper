#!/usr/bin/env bash

set -eu

source ./virtualenv/bin/activate

for file in "molecular_crystals" "silicon_bulk"; do
    echo  "================== $file =================="

    printf "QUIP\n"
    python bench-quip.py hypers.json $file.xyz no_grad

    printf "\nQUIP w/ gradients\n"
    python bench-quip.py hypers.json $file.xyz grad

    printf "\nlibrascal\n"
    python bench-librascal.py hypers.json $file.xyz no_grad

    printf "\nlibrascal w/ gradients\n"
    python bench-librascal.py hypers.json $file.xyz grad

    printf "\ndscribe\n"
    python bench-dscribe.py hypers.json $file.xyz no_grad

    printf "\ndscribe w/ gradients\n"
    python bench-dscribe.py hypers.json $file.xyz grad

    printf "\nspex CPU\n"
    python bench-spex.py hypers.json $file.xyz no_grad cpu

    printf "\nspex CUDA\n"
    python bench-spex.py hypers.json $file.xyz no_grad cuda

    printf "\nfeatomic\n"
    python bench-featomic.py hypers.json $file.xyz no_grad

    printf "\nfeatomic w/ gradients\n"
    python bench-featomic.py hypers.json $file.xyz grad
done
