# -*- mode:snakemake; -*-

rule do_minimization:
    input:
        config="resources/config_minim.ini",
        endpoint="resources/{endpoint}.con",
        model=expand(
            "results/pet-mad-{version}.pt", version=config["pet_mad"]["version"]
        ),
    output:
        # One of reactant or product
        endpoint="results/{endpoint}.con"
    shadow:
        "minimal"
    shell:
        """
        cp {input.config} config.ini
        cp {input.endpoint} pos.con
        cp {input.model} .
        eonclient
        cp min.con {output.endpoint}
        """

rule do_neb:
    input:
        config="resources/config_neb.ini",
        idpp_path="results/idppPath.dat",
        path_images=expand(
            "results/path/{num:02d}.con",
            num=range(config["common"]["number_of_intermediate_imgs"] + 2),
        ),
        model=expand(
            "results/pet-mad-{version}.pt", version=config["pet_mad"]["version"]
        ),
        reactant=config["common"]["reactant_file"],
        product=config["common"]["product_file"],
    output:
        results_dat="results/results.dat",
        neb_con="results/neb.con",
        neb_max_con="results/neb_maximage.con",
        all_neb_dat=expand(
            "results/neb_{num:03d}.dat", num=range(config["eon"]["num_steps"])
        ),
        all_neb_path_con=expand(
            "results/neb_path_{num:03d}.con", num=range(config["eon"]["num_steps"])
        ),
    shadow:
        "minimal"
    shell:
        """
        cp {input.config} results/config.ini
        cp {input.reactant} results
        cp {input.product} results
        cd results
        eonclient 2>&1 || true
        """
