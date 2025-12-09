"""
    visualize(grid)
Displays spacing and stretching of _grid_ as scatter plots over the vertical 
axis.
"""
function visualize(grid::Grid)
    s = collect(1:grid.nz)
    fig = Figure()

    # Plot the spacing as multiple of Δx
    ax = Axis(fig[1,1], xlabel="z", ylabel="Δz/Δx")
    itp = linear_interpolation(s, grid.z, extrapolation_bc = Line())
    spacing = ForwardDiff.derivative.(Ref(itp), s)
    scatter!(ax, grid.z, spacing ./ (grid.scalex/grid.nx))

    # PLot the stretching
    ax2 = Axis(fig[2,1], xlabel="z", ylabel="stretching in %")
    itp = linear_interpolation(s, spacing, extrapolation_bc = Line())
    stretching = ForwardDiff.derivative.(Ref(itp), s) ./ spacing .* 100
    scatter!(ax2, grid.z, stretching)

    println("Vertical stepsize:")
    println(grid.z[end - round(Int, grid.nz/2)-10] - grid.z[end - round(Int, grid.nz/2) - 11])
    println("Horiz. stepsize:")
    println(grid.x[end]/grid.nx)
    println("Maximum stretching in %:")
    println(maximum(stretching))

    display(fig)
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
        s = collect(1:grid.nz)

        # Plot the spacing as multiple of Δx
        itp = linear_interpolation(s, grid.z, extrapolation_bc = Line())
        spacing = ForwardDiff.derivative.(Ref(itp), s)
        scatter!(ax, grid.z, spacing ./ (grid.scalex/grid.nx))

        # PLot the stretching 
        itp = linear_interpolation(s, spacing, extrapolation_bc = Line())
        stretching = ForwardDiff.derivative.(Ref(itp), s) ./ spacing .* 100
        scatter!(ax2, grid.z, stretching)

        println("Vertical stepsize:")
        println(grid.z[end - round(Int, grid.nz/2)-10] - grid.z[end - round(Int, grid.nz/2) - 11])
        println("Horiz. stepsize:")
        println(grid.x[end]/grid.nx)
        println("Maximum stretching in %:")
        println(maximum(stretching))
    end

    display(fig)
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
        s = collect(1:grid.nz)

        # Plot the spacing as multiple of Δx
        itp = linear_interpolation(s, grid.z, extrapolation_bc = Line())
        spacing = ForwardDiff.derivative.(Ref(itp), s)
        scatter!(ax, grid.z, spacing ./ (grid.scalex/grid.nx))

        # PLot the stretching 
        itp = linear_interpolation(s, spacing, extrapolation_bc = Line())
        stretching = ForwardDiff.derivative.(Ref(itp), s) ./ spacing .* 100
        scatter!(ax2, grid.z, stretching, label=labels[i])

        println("Vertical stepsize:")
        println(grid.z[end - round(Int, grid.nz/2)-10] - grid.z[end - round(Int, grid.nz/2) - 11])
        println("Horiz. stepsize:")
        println(grid.x[end]/grid.nx)
        println("Maximum stretching in %:")
        println(maximum(stretching))
    end

    axislegend(ax2, position=:rb)
    display(fig)
end