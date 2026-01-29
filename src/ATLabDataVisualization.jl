module ATLabDataVisualization

using Reexport
using CairoMakie
using ImageFiltering
using Interpolations
using Integrals

@reexport using ATLabData

export visualize, heatmap, timeprofile
export theme_std, theme_article, theme_talk

include("THEMES.jl")

include("Grid.jl")

include("Averages.jl")

include("2D.jl")

function __init__()
    CairoMakie.activate!()
    set_theme!(theme_std())
end

end
