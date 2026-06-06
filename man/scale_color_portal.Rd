\name{scale_color_portal}
\alias{scale_color_portal}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Custom ggplot2 Color Scale for Portal Colors
}

\usage{
scale_color_portal(palette = "portal", discrete = TRUE, reverse = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{palette}{Character name of palette in my_palettes. Default is "portal".}

\item{discrete}{Logical. If TRUE (default), returns a discrete scale. If FALSE, returns a continuous gradient.}

\item{reverse}{Logical. If TRUE, reverses the color order.}
}

\value{
A ggplot2 scale object.
}

\examples{
library(ggplot2)

# Discrete scale example
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_portal()

# Continuous scale example
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_portal(discrete = FALSE)

}
