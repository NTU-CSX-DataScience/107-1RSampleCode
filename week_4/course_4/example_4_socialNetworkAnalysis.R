# example_5_socialNetworkAnalysis
## References

### sna package manual https://cran.r-project.org/web/packages/sna/sna.pdf
### igraph package manual http://igraph.org/r/doc/igraph.pdf
### Social Networks in R http://www.shizukalab.com/toolkits/sna
### Stanford Social Network Analysis Labs in R and SoNIA https://sna.stanford.edu/rlabs.php
### Prof.Wen, Department of Geography, NTU http://homepage.ntu.edu.tw/~wenthung/R_Network/

## interested in sna visualization?
### gephi https://gephi.org/
### sigmajs http://sigmajs.org/

############################################################
library(sna)
library(igraph)

# Matrix-type data
sna.data <- './sna_data_matrix.csv'
sna.df <- read.table(sna.data, header = T, row.names = 1, sep = ",")
sna.m <- as.matrix(sna.df)

sna::gplot(sna.m, displaylabels = T)

igraph::graph.full(sna.m)
############################################################
# Edgelist-type data
el.data <- './sna_data_edgelist.csv'
el.df <- read.table(el.data, header = T, sep = ',')
el.ig <- igraph::graph.data.frame(el.df, directed = T) # class(el.g) # igraph

# Check vertices and edges
igraph::V(graph = el.ig) # Check vertices
igraph::E(graph = el.ig) # Check edges0
igraph::vcount(el.ig)    # Check vertices count
igraph::ecount(el.ig)    # Check edges count

# Plot with igraph
igraph::plot.igraph(el.ig, 
                    vertex.color = "red", 
                    el.color = 'black', 
                    el.arrow.size = .7,
                    vertex.size = 20, 
                    main='Test Graph')


# Reset igraph info 
new.name <- c("K1", "K2", "K3", "K4", "K5", "K6", "K7") 
V(el.ig)$name # Get vertices name 
V(el.ig)$name <- new.name # Reset vertices name 
V(el.ig)$name # Get vertices name

# Check if weighted graph
E(el.ig)$weight  # NULL
is.weighted(el.ig)

# Reset it as weighted graph
E(el.ig)$weight <- runif(ecount(el.ig))
is.weighted(el.ig)

# Plot it again
igraph::plot.igraph(el.ig, 
                    vertex.color = "red", 
                    el.color = 'black', 
                    el.arrow.size = .2,
                    vertex.size = 20, 
                    edge.width = E(el.ig)$weight * 5,
                    main='Test Graph')


############################################################
# Transfer igraph to matrix
m <- get.adjacency(el.ig) # class(m) # dgMatrix

# Convert to regular matrix
m <- as.matrix(m)
