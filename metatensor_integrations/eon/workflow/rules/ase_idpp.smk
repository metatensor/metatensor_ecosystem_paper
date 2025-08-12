# -*- mode:snakemake; -*-


rule ase_idpp:
    input:
        reactant="resources/reactant.con",
        product="resources/product.con",
    params:
        niimgs=10,  #config["number_of_intermediate_imgs"],
        plfname="idppPath.dat",
    log:
        "logs/ase_idpp.log",
    output:
        ipath="results/idppPath.dat",
    run:
        import ase.io
        from ase.mep import NEB
        from pathlib import Path

        react = ase.io.read(input.reactant)
        prod = ase.io.read(input.product)
        images = [react]
        images += [react.copy() for i in range(params.niimgs)]
        images += [prod]
        neb = NEB(images)
        neb.interpolate("idpp")
        gen_paths = []
        for num, img in enumerate(images):
            fname = f"results/{num:02d}_path.con"
            ase.io.write(fname, img)
            gen_paths.append(Path(fname).resolve())

        with open(output.ipath, "w") as f:
            for path in gen_paths:
                f.write(f"{path}\n")
