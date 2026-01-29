function visualize(data::ScalarData; slice::Int=1)
    fig, ax, hm = heatmap(data, slice=slice)
    display(fig)
    return fig, ax, hm
end


function heatmap(
        data::ScalarData;
        slice::Int = 1, 
        colormap=:RdGy,
        colorrange = (
            -maximum(abs.(data.field)),
            maximum(abs.(data.field))
        ),
        colorscale = identity,
        colorbarticks = [
            round(colorrange[1], digits=2), 
            round((colorrange[2]+colorrange[1])/2, digits=2), 
            round(colorrange[2], digits=2)
        ],
        label=" ",
        xlabel = "x",
        ylabel = "z",
        xtickstep = 10,
        ytickstep = 10,
        title::String = data.name*"  ;  t = "*string(data.time)
    )::Tuple{Figure, Axis, Heatmap}
    println("Visualizing ...")
    printstyled("   $(data.name) \n", color=:cyan)
    printstyled("   Backend: CairoMakie \n", color=:light_black)
    
    fig = Figure()
    ax = Axis(
        fig[1,1], 
        xlabel=xlabel, ylabel=ylabel,
        xticks=data.grid.x[1]:xtickstep:data.grid.x[end],
        yticks=round(data.grid.z[1]):ytickstep:round(data.grid.z[end]),
        title=title,
        aspect = DataAspect()
    )    
    hm = heatmap!(
        ax,
        view(data.grid.x, :), 
        view(data.grid.z, :),
        # Resampler(view(data.field, :, slice, :)),
        view(data.field, :, slice, :),
        colormap=colormap,
        colorrange=colorrange,
        colorscale=colorscale
    )
    Colorbar(
        fig[1,2], 
        hm,
        label=label,
        ticks=colorbarticks
    )
    return fig, ax, hm
end


function animate(
        dir::String, 
        field::String;
        fps::Int=2,
        loader::Function=load,
        visualizer::Function=visualize,
        live::Bool=true,
        outfile::String=joinpath(dir, "video/$(field).mp4"),
        slice::Int=1
    )
    println("Animating:")
    printstyled("   $(dir)", color=:cyan)
    filenames = filter(x -> startswith(x, field), readdir(dir, join=false))
    file = joinpath(dir, filenames[1])
    data = loader(file)
    fig, ax, hm = visualizer(data)
    if live
        # Live in GLWindow using GLMakie
        display(fig)
        for i ∈ eachindex(filenames)
            file = joinpath(dir, filenames[i])
            data = loader(file)
            hm[3] = view(data.field, :, slice, :)
            ax.title = "$(field) ; t = $(data.time)"
            sleep(1/fps)
        end
    else
        # Save as .mp4 file with CairoMakie
        if ! ispath(dirname(outfile))
            mkpath(dirname(outfile))
        end
        record(fig, outfile, 1:length(filenames), framerate=fps) do i
            file = joinpath(dir, filenames[i])
            data = loader(file)
            hm[3] = view(data.field, :, slice, :)
            ax.title = "$(field) ; t = $(data.time)"
        end
    end
end