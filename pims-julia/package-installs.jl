metadata_packages = [
    "BinDeps",
    "Cairo",
    "Calculus",
    "Clustering",
    "Clp",
    "Colors",
    "DataFrames",
    "DataFramesMeta",
    "Dates",
    "DecisionTree",
    "Distributions",
    "Distances",
    "GLM",
    "GraphPlot",
    "HDF5",
    "HypothesisTests",
    "Ipopt",
    "IJulia",
    "JSON",
    "KernelDensity",
    "Lazy",
    "MLBase",
    "MultivariateStats",
    "NLopt",
    "NMF",
    "Optim",
    "ODE",
    "PDMats",
    "PGFPlots",
    "Plots",
    "PyCall",
    "PyPlot",
    "QuantEcon",
    "RDatasets",
    "SQLite",
    "Stan",
    "StatsBase",
    "Sundials",
    "TextAnalysis",
    "TimeSeries",
    "XGBoost"]

# Assume system wide location is second position in DEPOT_PATH
depot = DEPOT_PATH[2]
empty!(DEPOT_PATH)
push!(DEPOT_PATH, depot)

import Pkg

Pkg.update()

for package=metadata_packages
    Pkg.add(package)
end

for package=metadata_packages
    @eval using $(Symbol(package))
end

Pkg.resolve()
