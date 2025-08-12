# -*- mode:snakemake; -*-

rule plot_neb_path:
    input:
        con="results/neb.con",
        dat_files=expand("results/neb_{num:03d}.dat", num=range(config["eon"]["num_steps"])),
        path_files=expand("results/neb_path_{num:03d}.con", num=range(config["eon"]["num_steps"])),
    output:
        plot="results/plots/neb_path.png",
    params:
        plot_structures=config["plotting"]["plot_structures"],
        facecolor=config["plotting"]["facecolor"],
        title=config["plotting"]["title"],
    shell:
        """
        python -m rgpycrumbs.cli eon plt_neb \
            --con-file {input.con} \
            --output-file {output.plot} \
            --plot-structures "{params.plot_structures}" \
            --facecolor "{params.facecolor}" \
            --input-pattern "results/neb_*.dat" \
            --title "{params.title}"
        """
