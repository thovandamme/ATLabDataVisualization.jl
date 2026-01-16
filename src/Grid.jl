"""
    visualize(grid)
Displays spacing and stretching of _grid_ as scatter plots over the vertical 
axis.
"""
function visualize(grid::Grid)
    fig = Figure()
    # Plot the spacing as multiple of Δx
    ax = Axis(fig[1,1], xlabel="z", ylabel="Δz/Δx")
    Δz = diff(grid.z); Δx = grid.x[2] - grid.x[1]
    scatter!(ax, grid.z[1:end-1], Δz./Δx)
    # PLot the stretching
    ax2 = Axis(fig[2,1], xlabel="z", ylabel="stretching in %")
    scatter!(ax2, grid.z[1:end-2], GridMapping.stretching(grid))
    display(fig)
    return fig, ax, ax2
end


"""
    visualize(grids)
Displays spacing and stretching of each _grid_ in _grids_, where _grids_ has to 
be vector of type _Grid_.
"""
function visualize(grids::Vector{Grid{T,I}}) where {T<:AbstractFloat, I<:Signed}
    fig = Figure()
    ax = Axis(fig[1,1], xlabel="z", ylabel="Δz/Δx")
    ax2 = Axis(fig[2,1], xlabel="z", ylabel="stretching in %")
    for grid ∈ grids
        # Plot the spacing as multiple of Δx
        Δz = diff(grid.z); Δx = grid.x[2] - grid.x[1]
        scatter!(ax, grid.z[1:end-1], Δz./Δx)
        # PLot the stretching 
        scatter!(ax2, grid.z[1:end-2], GridMapping.stretching(grid))
    end
    display(fig)
    return fig, ax, ax2
end


"""
    visualize(grids, labels)
Displays spacing and stretching of each _grid_ in _grids_, where _grids_ has to 
be vector of type _Grid_. A grid with index _i_ in _grids_ is labelled with the 
_i_th entry in _labels_, where _labels_ has to be a vector of type String.
"""
function visualize(
        grids::Vector{Grid{T,I}},
        labels::Vector{String}
    ) where {T<:AbstractFloat, I<:Signed}
    fig = Figure()
    ax = Axis(fig[1,1], xlabel="z", ylabel="Δz/Δx")
    ax2 = Axis(fig[2,1], xlabel="z", ylabel="stretching in %")
    for (i, grid) ∈ enumerate(grids)
        # Plot the spacing as multiple of Δx
        Δz = diff(grid.z); Δx = grid.x[2] - grid.x[1]
        scatter!(ax, grid.z[1:end-1], Δz./Δx)
        # PLot the stretching 
        scatter!(ax2, grid.z[1:end-2], GridMapping.stretching(grid), label=labels[i])
    end
    axislegend(ax2, position=:rb)
    display(fig)
    return fig, ax, ax2
end