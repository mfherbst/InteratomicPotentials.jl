################################################################################
#
#    Module Potentials.jl
#
#    This module will implement a variety of interatomic potentials and defines abstract types
#    that allow these potentials to be used in other packages (PotentialLearning.jl, PotentialUQ.jl, 
#    Atomistic.jl, etc...). 
#       'implementation' means:
#           1. Having a defined structure for each potential
#               1.1 The structure holds all of the necessary parameters for evaluating energies, forces, ...
#               1.2 The potential structure should expose the trainable and nontrainable parameters (necessary for learning).
#           2. Having a method to get the potential energy of given configuration, as
#               defined by that potential.
#           3. Having a method to produce the force of a given configuration, as defined
#               by that potential.
#           4. Having a method to produce the stresses of a given configuration, as defined
#               by that potential.
#           5. (For inference) Having a method to produce the gradient of each of the above methods with 
#               respect to the potential parameters.
#
#       Right now, this module contains the framework for the following potentials
#           1. Lennard Jones
#           2. Born - Mayer 
#           3. Coulomb
#           4. ZBL
#           5. GaN (special mixed type, more of an application than a true potential)
#           6. SNAP 

#
#       To do:
#           1. Improve configuration implementation
#           2. Implement ACE potentials (with ACE.jl)
#
#
################################################################################
module InteratomicPotentials

using Base: Float64
using StaticArrays
using LAMMPS
using LinearAlgebra
using AtomsBase
using Unitful
using UnitfulAtomic
# include("Utilities/utils.jl")
# include("Configurations/config.jl")
# include("IO/io.jl")
include("PotentialTypes/types.jl")
include("PotentialTypes/SNAP/LAMMPS-RECODE/snap.jl")
# include("MD/md.jl")

export potential_energy, force, virial, virial_stress
export grad_potential_energy, grad_force, grad_virial, grad_virial_stress
export SNAPParams, compute_sna
export EmpiricalPotential, LennardJones
# export BornMayer, Coulomb, GaN, MixedPotential
# export SNAP, SNAPkeywords, get_bispectrum, get_dbispectrum, get_vbispectrum, get_snap
# export Atom, Angle, Bond, Configuration, Dihedral, Domain, Improper
# export load_lammps



end