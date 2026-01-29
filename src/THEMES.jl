function theme_defaults()::Theme
    return merge(theme_latexfonts(), Theme(
        palette = (
            color = [
                :forestgreen, :dodgerblue, :seashell4, :firebrick1, :deepskyblue,
                :gold, :darkcyan, :darkolivegreen
            ],
        ),
        Axis = (
            leftspinevisible = false,
            rightspinevisible = false,
            bottomspinevisible = false,
            topspinevisible = false,
            xminorticksvisible = false,
            yminorticksvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            xlabelpadding = 15,
            ylabelpadding = 15,
            titlefont = :bold,
        ),
        Legend = (
            framevisible = false,
        ),
        Axis3 = (
            xspinesvisible = false,
            yspinesvisible = false,
            zspinesvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            zticksvisible = false,
        ),
        Colorbar = (
            ticksvisible = false,
            spinewidth = 0,
            ticklabelpad = 5,
        ),
        Lines = (
            cycle = [:color],
            alpha = 0.75,
            linestyle = :solid,
            linewidth = 3,
        ),
        Scatter = (
            cycle = [:color],
            alpha = 0.75,
        ),
        Contour = (
            linewidth = 2
        ),
        Band = (
            alpha = 0.5,
        ),
    ))
end


function theme_std()::Theme
    return merge(
        Theme(
            size = (1600, 900),
            fontsize = 20,
        ), 
        theme_defaults()
    )
end


function theme_talk()::Theme
    return merge(
        Theme(
            size = (1600, 900),
            fontsize = 32,
            Lines = (linewidth=3,)
        ),
        theme_defaults()
    )
end


function theme_article()::Theme
    return merge(
        Theme(
            size = (1000, 600),
            fontsize = 25,
            figure_padding = 30,
            Lines = (linewidth=2,)
        ),
        theme_defaults()
    )
end