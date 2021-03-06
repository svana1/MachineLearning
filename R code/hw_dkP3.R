# Problem 3 (a)
g1 <- aging.prefatt.game(1000, pa.exp=1, aging.exp=-3, aging.bin=1000,directed=F)
g2 <- aging.prefatt.game(1000, pa.exp=1, aging.exp=-1, aging.bin=1000,directed=F)
g3 <- aging.prefatt.game(1000, pa.exp=1, aging.exp=-3, aging.bin=1000,directed=F)


plot(degree.distribution(g1), log='xy',type='o',xlab="Degree",ylab="Density",main="problem 3-(a)", col="red",xlim=c(1, 100),ylim=c(0.001, 0.500) )
par(new=TRUE)

plot(degree.distribution(g2), log='xy',type='o',xlab="Degree",ylab="Density",main="problem 3-(a)", col="blue",xlim=c(1, 100),ylim=c(0.001, 0.500) )
par(new=TRUE)

plot(degree.distribution(g3), log='xy',type='o',xlab="Degree",ylab="Density",main="problem 3-(a)", col="green",xlim=c(1, 100),ylim=c(0.001, 0.500) )

# Problem 3 (b)
# Clustering Graph
clusterlist <- clusters(g1) #change g1,g2,g3
size <- clusterlist$csize
numcluster <- clusterlist$no

# Find Community structure of Overall Graph
communityobj <- fastgreedy.community(g1, merges=TRUE, modularity=TRUE, membership=TRUE, weights=NULL)
# Modularity & Sizes of Communities
modularityval <- modularity(communityobj)
sizeofmembers <- sizes(communityobj)



# Find the GCC
GCCindex <- which.max(size)
nonGCCnodes<-(1:vcount(g1))[clusterlist$membership!=GCCindex] #compares the membership vector with the index , then multiply TRUE with node list
GCCfinal <- delete.vertices(g1,nonGCCnodes)

# Find Community structure of GCC
communityobjGCC = fastgreedy.community(GCCfinal, merges=TRUE, modularity=TRUE, membership=TRUE, weights=NULL)
# Modularity & Sizes of Communities
modularityvalGCC = modularity(communityobjGCC)
sizeofmembersGCC= sizes(communityobjGCC)

print(modularityval)
print(modularityvalGCC)
print(sizeofmembers)
print(sizeofmembersGCC)

plot(sizeofmembers,type='o')
plot(sizeofmembersGCC, type='o')
