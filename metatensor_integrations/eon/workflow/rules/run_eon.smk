# -*- mode:snakemake; -*-


rule run_eon:
    input:
        "resources/config.ini",
        "results/idppPath.dat",
        expand(
            "results/path/{num:02d}.con",
            num=range(config["common"]["number_of_intermediate_imgs"] + 2),
        ),
        expand("results/pet-mad-{version}.pt", version=config["pet_mad"]["version"]),
    output:
        "results/results.dat",
    shell:
        """
        cd results
        cp ../resources/config.ini .
        cp ../resources/{reactant,product}.con .
        eonclient
        """
