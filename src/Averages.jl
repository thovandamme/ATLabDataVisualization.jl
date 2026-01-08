let

global function visualize(data::AveragesData; T::Float64=2π)
    σ = collect(range(start=0, stop=10, length=101)).*T
    gaussvar = imfilter(data.field, Kernel.gaussian((0, σ[end])))

    # ------------------------------------------------------------------------------

    fig = Figure()
    sg = SliderGrid(
        fig[1, 1],
        (label=L"i_z", range=1:length(data.grid.z), startvalue=1410, linewidth=15),
        (label="σ", range=1:length(σ), startvalue=1, linewidth=15),
        (label=L"i_t", range=1:(length(data.time)), startvalue=100, linewidth=15)
    )
    z_slider = sg.sliders[1]
    σ_slider = sg.sliders[2]
    t_slider = sg.sliders[3]
    ax1 = Axis(fig[2,1], xlabel="t", ylabel=data.name)
    ax2 = Axis(fig[3,1], xlabel=data.name, ylabel="z")

    # ------------------------------------------------------------------------------

    ln1 = Vector{Lines}(undef, 2)
    ln2 = Vector{Lines}(undef, 2)

    ln1[1] = lines!(ax1, data.time, view(data.field, length(data.grid.z)÷2, :), linewidth=2)
    ln1[2] = lines!(ax1, data.time, view(gaussvar, length(data.grid.z)÷2, :), linewidth=4)
    ln1_v = vlines!(ax1, data.time[length(data.time)÷2], color=:black)

    ln2[1] = lines!(ax2, view(data.field, :, length(data.time)÷2), data.grid.z, linewidth=2)
    ln2[2] = lines!(ax2, view(gaussvar, :, length(data.time)÷2), data.grid.z, linewidth=4)
    ln2_h = hlines!(ax2, data.grid.z[length(data.grid.z)÷2], color=:black)

    # Initial profile; Interesting for comparing to initial conditions
    lines!(ax2, view(data.field, :, 1), data.grid.z, linewidth=2, linestyle=:dot)

    buffer = zeros(eltype(data.field), size(data.field))
    lift(σ_slider.value) do j
        s = σ[j] * length(data.time) / data.time[end]
        imfilter!(buffer, view(data.field, :, :), Kernel.gaussian( (0,s) ))
        
        lift(z_slider.value) do i
            ln1[1][2] = view(data.field, i, :)
            ln1[2][2] = view(buffer, i, :)
            ln2_h[1] = data.grid.z[i]

            lift(t_slider.value) do it
                ln1_v[1] = data.time[it]
                ln2[1][1] = view(data.field, :, it)
                ln2[2][1] = view(buffer, :, it)
                ax1.title = "t = $(data.time[it]) ; z = $(data.grid.z[i]) ; σ = $(σ[j])"
            end
        end
    end
    display(fig)
    return fig, ax1, ax2
end


# Most basic method
global function timeprofile(
        datas::Vector{AveragesData{T,I}};
        zmin::AbstractFloat, zmax::AbstractFloat,
        slider::Bool=true,
        filterscale::AbstractFloat=2π
    ) where {T<:AbstractFloat, I<:Signed}
    fig = Figure()
    σ = collect(range(start=0, stop=10, length=101)).*filterscale
    if slider
        ax = Axis(fig[2,1], xlabel="t", ylabel=datas[1].name)
        sg = SliderGrid(
            fig[1, 1],
            (label="Smoothing", range=1:length(σ), startvalue=1, linewidth=15),
        )
        σ_slider = sg.sliders[1]
    else
        ax = Axis(fig[1,1], xlabel="t", ylabel=datas[1].name)
    end
    ln_sol = Vector{Lines}(undef, length(datas))
    ln_ssol = Vector{Lines}(undef, length(datas))
    
    # Initialize the plot
    for (i, data) ∈ enumerate(datas)
        ln_sol[i] = lines!(
            ax, 
            view(data.time, :), 
            view(integrate(data, zmin, zmax), :),
            linestyle=:dot,
            linewidth=3
        )
        # Curve smoothing with Gaussian filter
        sol = integrate(data, zmin, zmax)
        ssol = imfilter(view(sol, :), Kernel.gaussian((σ[1],)))
        ln_ssol[i] = lines!(
            ax, 
            view(data.time, :), view(ssol, :), 
            linestyle=:solid,
            linewidth=4
        )
    end
  
    # Slider
    if slider
        lift(σ_slider.value) do j
            for (i, data) ∈ enumerate(datas)
                s = σ[j] * length(data.time) / data.time[end]
                ssol = imfilter(view(integrate(data, zmin, zmax), :), Kernel.gaussian( (s,) ))
                ln_ssol[i][2] = view(ssol, :)
            end
        end
    end

    display(fig)
    return fig, ax
end


# Method which adds an axislegend according to _labels_.
global function timeprofile(
        datas::Vector{AveragesData{T,I}},
        labels::Vector{String}; 
        zmin::AbstractFloat, zmax::AbstractFloat,
        slider::Bool=true,
        filterscale::AbstractFloat=2π
    ) where {T<:AbstractFloat, I<:Signed}
    fig = Figure()
    σ = collect(range(start=0, stop=10, length=101)).*filterscale
    if slider
        ax = Axis(fig[2,1], xlabel="t", ylabel=datas[1].name)
        sg = SliderGrid(
            fig[1, 1],
            (label="Smoothing", range=1:length(σ), startvalue=1, linewidth=15),
        )
        σ_slider = sg.sliders[1]
    else
        ax = Axis(fig[1,1], xlabel="t", ylabel=datas[1].name)
    end
    ln_sol = Vector{Lines}(undef, length(datas))
    ln_ssol = Vector{Lines}(undef, length(datas))

    # Initialize the plot
    for (i, data) ∈ enumerate(datas)
        ln_sol[i] = lines!(
            ax, 
            view(data.time, :), 
            view(integrate(data, zmin, zmax), :),
            linestyle=:dot,
            linewidth=3,
        )
        # Curve smoothing with Gaussian filter
        sol = integrate(data, zmin, zmax)
        ssol = imfilter(view(sol, :), Kernel.gaussian((σ[1],)))
        ln_ssol[i] = lines!(
            ax, 
            view(data.time, :), view(ssol, :), 
            linestyle=:solid,
            linewidth=4,
            label = labels[i]
        )
    end
  
    # Slider
    if slider
        lift(σ_slider.value) do j
            for (i, data) ∈ enumerate(datas)
                s = σ[j] * length(data.time) / data.time[end]
                ssol = imfilter(view(integrate(data, zmin, zmax), :), Kernel.gaussian( (s,) ))
                ln_ssol[i][2] = view(ssol, :)
            end
        end
    end

    axislegend(ax, position=:rt)
    display(fig)
    return fig, ax
end


# Method which works for different time axis lengths and different time step margins
global function timeprofile(
        dats::Vector{AveragesData{T,I}},
        labels::Vector{String},
        t::Vector{<:AbstractFloat}; 
        zmin::AbstractFloat, zmax::AbstractFloat,
        slider::Bool=true,
        filterscale::AbstractFloat=2π
    ) where {T<:AbstractFloat, I<:Signed}
    # Do the remapping in the new time axis (better here than inside the loop)
    datas = Vector{AveragesData{T,I}}(undef, length(dats))
    for (i, dat) ∈ enumerate(dats)
        datas[i] = remap(dat, t)
    end

    # Initialize the figure
    fig = Figure()
    σ = collect(range(start=0, stop=10, length=101)).*filterscale
    if slider
        ax = Axis(fig[2,1], xlabel="t", ylabel=datas[1].name)
        sg = SliderGrid(
            fig[1, 1],
            (label="Smoothing", range=1:length(σ), startvalue=1, linewidth=15),
        )
        σ_slider = sg.sliders[1]
    else
        ax = Axis(fig[1,1], xlabel="t", ylabel=datas[1].name)
    end
    ln_sol = Vector{Lines}(undef, length(datas))
    ln_ssol = Vector{Lines}(undef, length(datas))

    # Initialize the plot
    for (i, data) ∈ enumerate(datas)
        # data = remap(dat, t)
        ln_sol[i] = lines!(
            ax, 
            view(data.time, :), 
            view(integrate(data, zmin, zmax), :),
            linestyle=:dot,
            linewidth=3,
        )
        # Curve smoothing with Gaussian filter
        sol = integrate(data, zmin, zmax)
        ssol = imfilter(view(sol, :), Kernel.gaussian((σ[1],)))
        ln_ssol[i] = lines!(
            ax, 
            view(data.time, :), view(ssol, :), 
            linestyle=:solid,
            linewidth=4,
            label = labels[i]
        )
    end
  
    # Slider
    if slider
        lift(σ_slider.value) do j
            for (i, data) ∈ enumerate(datas)
                # data = remap(dat, t)
                s = σ[j] * length(data.time) / data.time[end]
                ssol = imfilter(view(integrate(data, zmin, zmax), :), Kernel.gaussian( (s,) ))
                ln_ssol[i][2] = view(ssol, :)
            end
        end
    end

    axislegend(ax, position=:rt)
    display(fig)
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