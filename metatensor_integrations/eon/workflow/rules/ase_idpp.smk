# -*- mode:snakemake; -*-

import ase.io
from ase.mep import NEB


# This rule performs the expensive interpolation once and writes all image files.
# It explicitly declares ALL of its outputs so the DAG is complete.
rule generate_idpp_images:
    input:
        reactant=config["reactant_file"],
        product=config["product_file"],
    output:
        # We declare all N+2 output files that will be generated.
        expand(
            "results/path/{num:02d}.con",
            num=range(config["number_of_intermediate_imgs"] + 2),
        ),
    params:
        niimgs=config["number_of_intermediate_imgs"],
    run:
        react = ase.io.read(input.reactant)
        prod = ase.io.read(input.product)

        # Create the list of images in memory
        images = [react]
        images += [react.copy() for i in range(params.niimgs)]
        images += [prod]

        neb = NEB(images)
        neb.interpolate("idpp")

        # Write each image to its corresponding, declared output file
        # The zip function ensures we match the correct image to the correct output path
        for outfile, img in zip(output, images):
            ase.io.write(outfile, img)


# Summary file for EON to use
rule collect_paths:
    input:
        # Depends on the output of the rule above.
        expand(
            "results/path/{num:02d}.con",
            num=range(config["number_of_intermediate_imgs"] + 2),
        ),
    output:
        "results/idppPath.dat",
    shell:
        # List the absolute paths of the inputs.
        "realpath {input} > {output}"
