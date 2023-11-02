# QMOF Bandgap Prediction

## Overview
This repository hosts the code for training a graph neural network (GCNN) by using [AtomicGraphNets.jl](https://atomicgraphnets.chemellia.org/dev/) package to predict the bandgap of Quantum Metal–Organic Frameworks (QMOFs). It is designed to run on Julia with distributed processing capabilities.

## Getting Started
To use this code, you need to have Julia installed on your system along with several packages. Ensure that your environment is set up with these dependencies before running the code.
1. Install Julia: Julia can be downloaded [here](https://julialang.org/downloads/) on your local computer.
2. Add Julia packages: open the Julia command-line and type the following command.
   ```
   using Pkg
   ```
   ```
   Pkg.add("...")  # Replace ... with the package name you want to add
   ```
Packages used in this code:
- [CSV](https://csv.juliadata.org/stable/)
- [DataFrames](https://dataframes.juliadata.org/stable/)
- [CUDA](https://cuda.juliagpu.org/stable/)
- [Random](https://docs.julialang.org/en/v1/stdlib/Random/)
- [Statistics](https://docs.julialang.org/en/v1/stdlib/Statistics/)
- [Flux](https://fluxml.ai/Flux.jl/stable/)
- [AtomGraphs](https://github.com/Chemellia/AtomGraphs.jl)
- [ChemistryFeaturization](https://chemistryfeaturization.chemellia.org/dev/)
- [AtomicGraphNets](https://atomicgraphnets.chemellia.org/dev/)
- [Distributed](https://docs.julialang.org/en/v1/stdlib/Distributed/)

## Usage
1. Data preparation - [data.jl](https://github.com/ACME-group-CMU/AtomicGraphNets-QMOF/blob/main/data.jl): before training, data is read and prepared.
2. Machine learning model - [model.jl](https://github.com/ACME-group-CMU/AtomicGraphNets-QMOF/blob/main/model.jl): implement the ML model.
3. Initiate training process - [train.jl](https://github.com/ACME-group-CMU/AtomicGraphNets-QMOF/blob/main/train.jl): parallelly train the ML model.

## Running job on TRACE
1. Create a file with the code that you want to run on TRACE.
2. Create a batch script like [run_job.job](https://github.com/ACME-group-CMU/AtomicGraphNets-QMOF/blob/main/run_job.job).
   
   - Replace *" /trace/home/tzuhsuac/julia-1.8.5/bin/julia "* with the path containing Julia in your TRACE.
   - Replace *" qmof.jl "* with the file containing the code you want to run.
3. Submit the batch script by typing the following command in TRACE command-line.
   ```
   sbatch run_job.job  # Replace run_job.job with your script
   ```
4. Check on the job progress by typing the following command in TRACE command-line.
   ```
   squeue -u ...  # Replace ... with your Andrew ID
   ```
Please refer to [TRACE Public Resources](https://cmu-enterprise.atlassian.net/wiki/spaces/TPR/overview?homepageId=2301461445) for detailed information and other options to the sbatch command.

## Data
### Properties of Chemical Elements
The CSV file containing the required properties values of each element can be found [here](https://github.com/ACME-group-CMU/AtomicGraphNets-QMOF/blob/main/dataset/property.xlsx).
### QMOF
The landing page for the QMOF database can be found at this [GitHub repository](https://github.com/arosen93/QMOF). 

The data related to the QMOF database is hosted on Figshare, bearing the permanent DOI: [10.6084/m9.figshare.13147324](https://figshare.com/articles/dataset/QMOF_Database/13147324).

## Citation
- Rosen, Andrew S., et al. "Machine learning the quantum-chemical properties of metal–organic frameworks for accelerated materials discovery." *Matter* 4.5 (2021): 1578-1597. DOI: [10.1016/j.matt.2021.02.015](https://www.sciencedirect.com/science/article/pii/S2590238521000709?via%3Dihub).
- Xie, Tian, and Jeffrey C. Grossman. "Crystal graph convolutional neural networks for an accurate and interpretable prediction of material properties." *Physical review letters* 120.14 (2018): 145301. DOI: [10.1103/physrevlett.120.145301](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.120.145301)

