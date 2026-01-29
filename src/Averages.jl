let

global function visualize(data::AveragesData; t::Real)
    it = argmin(abs.(data.time .- t))
    fig = Figure()
    ax = Axis(
        fig[1,1],
        title = L"\mathbf{t=%$(data.time[it])}",
        xlabel = data.name,
        ylabel = L"z",
    )
    lines!(ax, data.grid.z, data.field[:,it])
    return fig, ax
end


# Put into ATLabData?
@inline function integrate(
        data::AveragesData{T,I}, 
        zmin::AbstractFloat, 
        zmax::AbstractFloat
    )::Vector{T} where {T<:AbstractFloat, I<:Signed}
    sol = zeros(eltype(data.time), size(data.time))
    imin = findmin(abs.(data.grid.z .- zmin))[2]
    imax = findmin(abs.(data.grid.z .- zmax))[2]
    for it ∈ eachindex(sol)
        prob = SampledIntegralProblem(data.field[imin:imax,it], data.grid.z[imin:imax])
        sol[it] = solve(prob, TrapezoidalRule()).u
    end
    return sol
end


# Put into ATLabData? Make one API with transform_grid
@inline function remap(data::AveragesData, t::Vector{<:AbstractFloat})::AveragesData
    i = findmin(abs.(t .- data.time[end]))[2]
    res = AveragesData(
        data.name, 
        convert(Vector{eltype(data)[1]}, t[1:i-1]), 
        data.grid, 
        zeros(eltype(data)[1], (data.grid.nz, length(t[1:i-1])))
    )
    for k ∈ eachindex(res.grid.z)
        itp = interpolate((data.time,), data.field[k,:], Gridded(Linear()))
        for it ∈ eachindex(res.time)
            res.field[k,it] = itp(res.time[it])
        end
    end
    return res
end


end # End of let scope