"""
DESCRIPTION
--------------------------------------------------------------------------------------------
This code is about data preparation
"""

# Read information about quantum materials from a CSV file (replace this w/ your directory)
info = CSV.read("./qmof/property.csv", DataFrame)

# Create a new DataFrame to store relevant material properties
df = DataFrame()
df.Symbol = info[!, Symbol("Element")]
df.Ionization_energy = info[!, Symbol("ln_I")]
df.Electron_affinity = info[!, Symbol("Electron affinity")]
df.Atomic_volume = info[!, Symbol("ln_V")]
df.Covalent_radius = info[!, Symbol("Covalent radius")]
df.Valence = info[!, Symbol("Valence")]
df.X = info[!, Symbol("X")]

# Define element feature descriptors based on the DataFrame columns for use in machine learning model
I = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Ionization_energy", df)
EA = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Electron_affinity", df)
V = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Atomic_volume", df)
R = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Covalent_radius", df)
VA = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Valence", df)
X = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("X", df)
G = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Group")
P = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Row")
B = ChemistryFeaturization.ElementFeature.ElementFeatureDescriptor("Block")