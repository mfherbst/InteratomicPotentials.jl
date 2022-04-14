struct LinearCombinationPotential <: MixedPotential
    potentials::Vector{ArbitraryPotential}
    coefficients::Vector{AbstractFloat}
end
LinearCombinationPotential(p::ArbitraryPotential) = LinearCombinationPotential([p], [1])
LinearCombinationPotential(p::LinearCombinationPotential) = p

Base.:+(p::ArbitraryPotential) = +1 * p
Base.:-(p::ArbitraryPotential) = -1 * p
Base.:+(p1::ArbitraryPotential, p2::ArbitraryPotential) = LinearCombinationPotential(p1) + LinearCombinationPotential(p2)
Base.:-(p1::ArbitraryPotential, p2::ArbitraryPotential) = p1 + -p2
Base.:*(a::Real, p::ArbitraryPotential) = a * LinearCombinationPotential(p)
Base.:/(p::ArbitraryPotential, a::Real) = (1.0 / a) * p

Base.:+(mp1::LinearCombinationPotential, mp2::LinearCombinationPotential) = LinearCombinationPotential(vcat(mp1.potentials, mp2.potentials), vcat(mp1.coefficients, mp2.coefficients))
Base.:*(a::Real, mp::LinearCombinationPotential) = LinearCombinationPotential(mp.potentials, a * mp.coefficients)

_apply_linear_combination(f::Function, sys::AbstractSystem, mp::LinearCombinationPotential) = sum(c * f(sys, p) for (p, c) in zip(mp.potentials, mp.coefficients))

function energy_and_force(sys::AbstractSystem, mp::LinearCombinationPotential)
    efs = [energy_and_force(sys, p) for p in mp.potentials]
    e = sum(c * ef.e for (ef, c) in zip(efs, mp.coefficients))
    f = sum(c * ef.f for (ef, c) in zip(efs, mp.coefficients))
    (; e, f)
end

potential_energy(sys::AbstractSystem, mp::LinearCombinationPotential) = _apply_linear_combination(potential_energy, sys, mp)
force(sys::AbstractSystem, mp::LinearCombinationPotential) = _apply_linear_combination(force, sys, mp)
virial(sys::AbstractSystem, mp::LinearCombinationPotential) = _apply_linear_combination(virial, sys, mp)
virial_stress(sys::AbstractSystem, mp::LinearCombinationPotential) = _apply_linear_combination(virial_stress, sys, mp)
