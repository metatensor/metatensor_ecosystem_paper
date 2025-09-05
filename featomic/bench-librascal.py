import json
import resource
import sys
import time

import ase.io
from rascal.representations import SphericalInvariants


with open(sys.argv[1]) as fd:
    HYPERS = json.load(fd)

frames = ase.io.read(sys.argv[2], ":")

for frame in frames:
    frame.wrap(eps=1e-10)

n_atoms = sum(len(f) for f in frames)

do_grad = sys.argv[3] == "grad"

calculator = SphericalInvariants(
    soap_type="PowerSpectrum",
    interaction_cutoff=HYPERS["cutoff"],
    cutoff_smooth_width=HYPERS["cutoff_width"],
    max_radial=HYPERS["max_radial"] + 1,
    max_angular=HYPERS["max_angular"],
    gaussian_sigma_type="Constant",
    gaussian_sigma_constant=HYPERS["atomic_width"],
    compute_gradients=do_grad,
)

# warmup
for _ in range(3):
    result = calculator.transform(frames)
    _ = result.get_features(calculator)

start = time.time()
for _ in range(HYPERS["n_iters"]):
    result = calculator.transform(frames)
_ = result.get_features(calculator)
stop = time.time()
print(1e3 * (stop - start) / HYPERS["n_iters"] / n_atoms, "ms/atom")

if sys.platform.startswith("linux"):
    max_mem_mib = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1024
else:
    max_mem_mib = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1024 / 1024

print(max_mem_mib / n_atoms, "MiB/atom")
