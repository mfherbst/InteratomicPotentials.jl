################################################################################
# Types of Empirical Potentials
################################################################################

include("../empirical/lj.jl")
include("../empirical/bm.jl")
include("../empirical/coulomb.jl")
include("../empirical/zbl.jl")
include("../empirical/morse.jl")

export LennardJones, BornMayer, Coulomb, ZBL, Morse

################################################################################
# InteratomicPotentials API implementations for empirical potentials
################################################################################

force(r::SVector{3}, p::EmpiricalPotential) = force(norm(r), r, p)

function energy_and_force(A::AbstractSystem, p::EmpiricalPotential)
    nnlist = neighborlist(A, get_rcutoff(p))

    e = 0.0
    f = fill(SVector{3}(zeros(3)), length(A))
    for ii in 1:length(A)
        for (jj, r, R) in zip(nnlist.j[ii], nnlist.r[ii], nnlist.R[ii])
            if (ismissing(get_species(p)) || (atomic_symbol(A, ii), atomic_symbol(A, jj)) ⊆ get_species(p))
                e += potential_energy(R, p)
                fo = force(R, r, p)
                f[ii] = f[ii] + fo
                f[jj] = f[jj] - fo
            end
        end
    end
    (; e=e * ENERGY_UNIT, f=f * FORCE_UNIT)
end

function virial_stress(A::AbstractSystem, p::EmpiricalPotential)
    nnlist = neighborlist(A, get_rcutoff(p))

    v = @SVector zeros(6)
    for ii in 1:length(A)
        for (r, R) in zip(nnlist.r[ii], nnlist.R[ii])
            vi = r * force(R, r, p)'
            v += @SVector [vi[1, 1], vi[2, 2], vi[3, 3], vi[3, 2], vi[3, 1], vi[2, 1]]
        end
    end
    v * ENERGY_UNIT
end
