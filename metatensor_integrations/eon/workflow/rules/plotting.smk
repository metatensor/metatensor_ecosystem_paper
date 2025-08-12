# -*- mode:snakemake; -*-


rule plot_neb_path:
    input:
        con=f"{config['paths']['neb']}/neb.con",
        dat_files=expand(
            f"{config['paths']['neb']}/neb_{{num:03d}}.dat",
            num=range(config["eon"]["num_steps"]),
        ),
    output:
        plot=f"{config['paths']['plots']}/neb_path.png",
    params:
        plot_structures=config["plotting"]["plot_structures"],
        facecolor=config["plotting"]["facecolor"],
        title=config["plotting"]["title"],
        ipath=config["paths"]["neb"],
    shell:
        """
        python -m rgpycrumbs.cli eon plt_neb \
            --con-file {input.con} \
            --output-file {output.plot} \
            --plot-structures "{params.plot_structures}" \
            --facecolor "{params.facecolor}" \
            --input-pattern "{params.ipath}/neb_*.dat" \
            --title "{params.title}"
        """
