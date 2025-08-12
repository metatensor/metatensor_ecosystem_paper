# -*- mode:snakemake; -*-


rule download_ckpt:
    output:
        # Promise to create a .ckpt file, which is what the URL provides.
        # Mark it as temp() since it is only for the next step.
        temp("results/pet-mad-{version}.ckpt"),
    params:
        version="{version}",
    shell:
        """
        curl -fL -o {output} \
        'https://huggingface.co/lab-cosmo/pet-mad/resolve/{params.version}/models/pet-mad-{params.version}.ckpt'
        """


rule convert_ckpt_to_pt:
    input:
        "results/pet-mad-{version}.ckpt",
    output:
        protected("results/pet-mad-{version}.pt"),
    shell:
        """
        mtt export results/pet-mad-{wildcards.version}.ckpt
        mv pet-mad-{wildcards.version}.pt {output}
        """
