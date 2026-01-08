function theme_defaults()::Theme
    return merge(theme_latexfonts(), Theme(
        palette = (
            color = [
                :forestgreen, :dodgerblue, :seashell4, :firebrick1, :deepskyblue,
                :gold, :darkcyan, :darkred, :darkolivegreen
            ],
            linestyle = [:dot, :solid],
            linewidth = [3, 5]
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
           cycle = Cycle([:color], covary=true),
           alpha = 0.75
        ),
        # Contour = (
        #     linewidth = 5
        # ),
        Band = (
            alpha = 0.5,
        ),
    ))
end


function theme_std()::Theme
    return merge(theme_defaults(), Theme(
        size = (1600, 900),
        fontsize = 20,
    ))
end


function theme_talk()::Theme
    return merge(theme_defaults(), Theme(
        size = (1600, 900),
        fontsize = 32,
    ))
end


function theme_article()::Theme
    return merge(theme_defaults(), Theme(
        size = (1000, 600),
        fontsize = 25,
        figure_padding = 30
    ))
end