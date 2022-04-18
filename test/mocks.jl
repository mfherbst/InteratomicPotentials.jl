struct MockAbstractPotential <: AbstractPotential
    seed::Float64
end
function InteratomicPotentials.energy_and_force(A::AbstractSystem, p::MockAbstractPotential)
    (
        e=(p.seed)u"hartree",
        f=fill((@SVector[p.seed + 1, p.seed + 2, p.seed + 3])u"hartree/bohr", length(A))
    )
end
function InteratomicPotentials.virial_stress(A::AbstractSystem, p::MockAbstractPotential)
    (@SVector [p.seed - 1, p.seed - 2, p.seed - 3, p.seed - 4, p.seed - 5, p.seed - 6])u"hartree"
end

struct MockEmpiricalPotential <: EmpiricalPotential{NamedTuple{},NamedTuple{}}
    seed::Float64
    rcutoff::Float64
    species::Tuple
end
InteratomicPotentials.get_rcutoff(p::MockEmpiricalPotential) = p.rcutoff
InteratomicPotentials.get_species(p::MockEmpiricalPotential) = p.species
function InteratomicPotentials.potential_energy(R::AbstractFloat, p::MockEmpiricalPotential)
    R^2 * p.seed
end
function InteratomicPotentials.force(R::AbstractFloat, r::SVector{3}, p::MockEmpiricalPotential)
    R^2 * p.seed * r
end
