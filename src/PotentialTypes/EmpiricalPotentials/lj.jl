############################## Lennard Jones ###################################
struct LennardJones <: EmpiricalPotential
    ϵ
    σ
    rcutoff
    species::AbstractVector
end
function LennardJones(ϵ::Unitful.Energy, σ::Unitful.Length, rcutoff::Unitful.Length, species::AbstractVector)
    LennardJones(austrip(ϵ), austrip(σ), austrip(rcutoff), species)
end

get_parameters(lj::LennardJones) = Parameter{(:ϵ, :σ)}((lj.ϵ, lj.σ))
set_parameters(p::Parameter{(:ϵ, :σ)}, lj::LennardJones) = LennardJones(p.ϵ, p.σ, lj.rcutoff, lj.species)

deserialize_parameters(p::Parameter{(:ϵ, :σ)}, lj::LennardJones) = [p.ϵ, p.σ]
serialize_parameters(p::Vector, lj::LennardJones) = Parameter{(:ϵ, :σ)}((p[1], p[2]))

get_hyperparameters(lj::LennardJones) = Parameter{(:rcutoff,)}((lj.rcutoff,))
set_hyperparameters(p::Parameter{(:rcutoff,)}, lj::LennardJones) = LennardJones(lj.ϵ, lj.σ, p.rcutoff, lj.species)

deserialize_hyperparameters(p::Parameter{(:rcutoff,)}, lj::LennardJones) = [p.rcutoff]
serialize_hyperparameters(p::Vector, lj::LennardJones) = Parameter{(:rcutoff,)}((p[1],))

potential_energy(R::AbstractFloat, lj::LennardJones) = 4lj.ϵ * ((lj.σ / R)^12 - (lj.σ / R)^6)
force(R::AbstractFloat, r::SVector{3}, lj::LennardJones) = (24lj.ϵ * (2(lj.σ / R)^12 - (lj.σ / R)^6) / R^2)r
