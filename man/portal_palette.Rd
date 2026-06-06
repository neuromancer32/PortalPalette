\name{portal_palette}
\alias{portal_palette}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Portal Color Palette Generator
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
portal_palette <- function(palette = "portal", reverse = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{palette}{Character name of palette in my_palettes. Default is "main".}

\item{reverse}{Logical. If TRUE, reverses the order of colors.}
}

\value{
A function that takes an integer \code{n} and returns a vector of \code{n} hex colors.
}
\examples{
# Get a function that generates 5 colors from the portal palette
pal <- portal_palette(palette = "portal")
pal(5)

# Get reversed colors
pal <- portal_palette(palette = "portal", reverse = TRUE)(3)
}
