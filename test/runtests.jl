using Test

@time begin
@testset "Potentials.jl" begin
    # include("lj_test.jl")
    include("SNAP/snap_test_single_element.jl")
    include("SNAP/snap_test_multi_element.jl")
end
end

