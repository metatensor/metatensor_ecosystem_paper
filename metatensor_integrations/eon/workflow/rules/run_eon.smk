# -*- mode:snakemake; -*-


rule run_eon:
    input:
        config="resources/config.ini",
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
        all_neb_dat=expand("results/neb_{num:03d}.dat", num=range(117)),
        all_neb_path_con=expand("results/neb_path_{num:03d}.con", num=range(117)),
    shadow:
        "minimal"
    shell:
        """
        cp {input.config} results
        cp {input.reactant} results
        cp {input.product} results
        cd results
        eonclient 2>&1 || true
        """
