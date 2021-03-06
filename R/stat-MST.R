#' @title Euclidean Minimum Spanning Tree Stat Function
#'
#' @description A Stat extension for 'ggplot2' to plot a 2D MST by making a 
#'     scatter plot with segments.
#' @description \code{stat_MST} uses the information returned by 
#'    \code{\link[emstreeR]{ComputeMST}} for producing a 2D Minimum Spanning 
#'    Tree plot with 'ggplot2' and should be combined with \code{geom_point()}.
#'    
#' @param mapping The aesthetic mapping, usually constructed with
#'   \code{\link[ggplot2]{aes}} or \code{\link[ggplot2]{aes_}}. 
#'    The required aesthetics are \code{x}, \code{y}, \code{from}, and \code{to}. 
#'    Those are columns of the \code{mst} object returned by 
#'    \code{\link[emstreeR]{ComputeMST}}.
#' @param data a \code{mst} class object returned by the 
#'    \code{\link[emstreeR]{ComputeMST}} function.
#' @param geom The geometric object to display the data. The default value is
#'    \code{"segment"} in order to produce the edges between the vertices.
#' @param position The position adjustment to use for overlapping points on this
#'    layer
#' @param show.legend logical. Should this layer be included in the legends?
#'    \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
#'    never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather
#'    than combining with them. This is most useful for helper functions that
#'    define both data and aesthetics and shouldn't inherit behaviour from the
#'    default plot specification, e.g. \code{\link[ggplot2]{borders}}.
#' @param linetype an integer or name: \code{0 = "blank"}, \code{1 = "solid"},
#'    \code{2 = "dashed"}, \code{3 = "dotted"}, \code{4 = "dotdash"}, 
#'    \code{5 = "longdash"}, \code{6 = "twodash"}. The default for \code{'MST'} 
#'    objects is "dotted".
#' @param ... other arguments passed on to \code{\link[ggplot2]{layer}}. This
#'    can include aesthetics whose values you want to set, not map. See
#'    \code{\link[ggplot2]{layer}} for more details.
#' @param na.rm	a logical value indicating whether \code{NA} values should be 
#' stripped before the computation proceeds.
#'
#' @section Computed variables: \describe{ 
#'    \item{x}{x coordinates of the MST start points}
#'    \item{y}{y coordinates of the MST start points}
#'    \item{xend}{x coordinates of the MST end points}
#'    \item{yend}{y coordinates of the MST end points}
#'    }
#'
#' @examples
#' 
#' ## 2D artificial data:
#' set.seed(1984)
#' n <- 15
#' c1 <- data.frame(x = rnorm(n, -0.2, sd = 0.2), y = rnorm(n, -2, sd = 0.2))
#' c2 <- data.frame(x = rnorm(n, -1.1, sd = 0.15), y = rnorm(n, -2, sd = 0.3)) 
#' d <- rbind(c1, c2)
#' d <- as.data.frame(d)
#' 
#' ## MST:
#' out <- ComputeMST(d)
#' 
#' #1) simple plot
#' library(ggplot2)
#' ggplot(data = out, 
#'     aes(x = x, y = y, 
#'     from = from, to = to))+ 
#'     geom_point()+
#'     stat_MST(colour = "red", linetype = 2)
#'     
#' #2) curved edges
#' library(ggplot2)
#' ggplot(data = out, 
#'     aes(x = x, y = y, 
#'     from = from, to = to))+ 
#'     geom_point()+
#'     stat_MST(geom = "curve", colour = "red", linetype = 2)
#'
#' \dontrun{
#' ## plotting MST on maps:
#' library(ggmap)
#' 
#' #3) honeymoon cruise example
#' # define ports
#' df.port_locations <- data.frame(location = c("Civitavecchia, Italy",
#'                                              "Genova, Italy",
#'                                              "Marseille, France",
#'                                              "Barcelona, Spain",
#'                                              "Tunis, Tunisia",
#'                                              "Palermo, Italy"), 
#'                                 stringsAsFactors = FALSE)
#' 
#' # get latitude and longitude
#' geo.port_locations <- geocode(df.port_locations$location, source = "dsk")
#' 
#' # combine data
#' df.port_locations <- cbind(df.port_locations, geo.port_locations)
#' 
#' # MST
#' out <- ComputeMST(df.port_locations[,2:3])
#' plot(out) #just to check
#' 
#' # Plot
#' #' map <- c(left = -8, bottom = 32, right = 20, top = 47)
#' 
#' get_stamenmap(map, zoom = 5) %>% ggmap()+
#'   stat_MST(data = out, 
#'            aes(x = lon, y = lat, from = from, to = to), 
#'            colour = "red", linetype = 2)+
#'   geom_point(data = out, aes(x = lon, y = lat), size = 3)
#' 
#' 
#' #4) World Map travels:
#' library(ggplot2)
#' library(ggmaps)
#' 
#' country_coords_txt <- "
#'    1     3.00000  28.00000       Algeria
#'    2    54.00000  24.00000           UAE
#'    3   139.75309  35.68536         Japan
#'    4    45.00000  25.00000 'Saudi Arabia'
#'    5     9.00000  34.00000       Tunisia
#'    6     5.75000  52.50000   Netherlands
#'    7   103.80000   1.36667     Singapore
#'    8   124.10000  -8.36667         Korea
#'    9    -2.69531  54.75844            UK
#'    10    34.91155  39.05901        Turkey
#'    11  -113.64258  60.10867        Canada
#'    12    77.00000  20.00000         India
#'    13    25.00000  46.00000       Romania
#'    14   135.00000 -25.00000     Australia
#'    15    10.00000  62.00000        Norway"
#'    
#'    
#'  d <- read.delim(text = country_coords_txt, header = FALSE, 
#'    quote = "'", sep = "", col.names = c('id', 'lon', 'lat', 'name'))
#'    
#'  out <- ComputeMST(d[,2:3])
#'  
#'  country_shapes <- geom_polygon(aes(x = long, y = lat, group = group),
#'    data = map_data('world'), fill = "#CECECE", color = "#515151", 
#'    size = 0.15)
#'    
#'  ggplot()+ country_shapes+
#'    stat_MST(geomdata = out, aes(x = lon, y = lat, from = from, to = to), 
#'      colour = "red", linetype = 2)+
#'    geom_point(data = out, aes(x = lon, y = lat), size=2)
#'}
#'
#' @export
#' 
stat_MST <- function(mapping = NULL, data = NULL, geom = "segment", 
                     position = "identity", na.rm = FALSE, 
                     linetype="dotted", show.legend = NA, 
                     inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatMST, 
    data = data, 
    mapping = mapping, 
    geom = geom, 
    position = position, 
    show.legend = show.legend, 
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, linetype = linetype, ...)
  )
}

#' @title 'ggproto' objects
#'
#' @description Internal use only definitions of 'ggproto' objects needed for
#'   geoms and stats.
#'
#' @name emstreeR-ggproto
#' @format NULL
#' @usage NULL
#' @keywords internal
NULL
#> NULL

#' @rdname emstreeR-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatMST <- ggplot2::ggproto("StatMST", ggplot2::Stat,
                       compute_group = function(data, scales, ...) {
                         ## Compute the line segment endpoints
                         
                         # change the last row's from/to columns
                         # repeat the row above
                         # this is done in order to work with geom="curve"
                         # avoiding the Error in calcCurveGrob(x, x$debug) : 
                         #.. end points must not be identical
                         data[nrow(data), c("from", "to")] <- 
                           c(
                             data[1, "from"], data[1, "to"]
                             )
                         
                         x = data[data$from, 1]
                         y = data[data$from, 2]
                         xend = data[data$to, 1]
                         yend = data[data$to, 2]
                         
                         data.frame(x=x, y=y, xend=xend, yend=yend)
                         
                       },
                       required_aes = c("x", "y", "from", "to")
)
