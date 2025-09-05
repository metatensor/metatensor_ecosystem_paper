import json
import resource
import sys
import time

import ase.io
from featomic import SoapPowerSpectrum


with open(sys.argv[1]) as fd:
    HYPERS = json.load(fd)


frames = ase.io.read(sys.argv[2], ":")
n_atoms = sum(len(f) for f in frames)

calculator = SoapPowerSpectrum(
    cutoff={
        "radius": HYPERS["cutoff"],
        "smoothing": {
            "type": "ShiftedCosine",
            "width": HYPERS["cutoff_width"],
        },
    },
    density={
        "type": "Gaussian",
        "width": HYPERS["atomic_width"],
    },
    basis={
        "type": "TensorProduct",
        "max_angular": HYPERS["max_angular"],
        "radial": {
            "type": "Gto",
            "max_radial": HYPERS["max_radial"],
        },
    },
)

# warmup
for _ in range(3):
    _ = calculator.compute(frames)

if sys.argv[3] == "grad":
    gradients = ["positions"]
else:
    gradients = None


start = time.time()
for _ in range(HYPERS["n_iters"]):
    _ = calculator.compute(frames, gradients=gradients)
stop = time.time()
print(1e3 * (stop - start) / HYPERS["n_iters"] / n_atoms, "ms/atom")

if sys.platform.startswith("linux"):
    max_mem_mib = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1024
else:
    max_mem_mib = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1024 / 1024

print(max_mem_mib / n_atoms, "MiB/atom")
