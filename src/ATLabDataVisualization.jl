module ATLabDataVisualization

using GLMakie
using ATLabData
using ImageFiltering
using ForwardDiff
using Interpolations
using Integrals

export visualize, animate, heatmap, timeprofile
export theme_article, theme_talk

include("THEMES.jl")

include("Grid.jl")

include("Averages.jl")

include("2D.jl")

include("3D.jl")

function __init__()
    GLMakie.activate!()
    set_theme!(theme_std())
end

end
