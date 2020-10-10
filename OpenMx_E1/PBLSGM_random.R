## Required libraries
#####################
Sys.setenv(OMP_NUM_THREADS = parallel::detectCores() - 1)
library(OpenMx)

## Set the number of repeated measures
#######################################
p <- 10

## Original parameter setting
##############################
mean0Y <- c(98, 5, 2.6, 3.5)
mean0Z <- c(102, 5, 2.6, 5.5)
psi0Y <- psi0Z <- matrix(c(25, 1.5, 1.5, 0.45,
                           1.5, 1.0, 0.3, 0.09,
                           1.5, 0.3, 1.0, 0.09,
                           0.45, 0.09, 0.09, 0.09), nrow = 4)
psi0Y0Z <- matrix(c(7.5, 1.5, 1.5, 0.45,
                    1.5, 0.3, 0.3, 0.09, 
                    1.5, 0.3, 0.3, 0.09,
                    0.45, 0.09, 0.09, 0.029), nrow = 4)

psi0 <- cbind(rbind(psi0Y, psi0Y0Z), rbind(psi0Y0Z, psi0Z))
sdY <- sdZ <- 1

true <- c(mean0Y, mean0Z, psi0[row(psi0) >= col(psi0)], sdY, sdZ, 0.3 * sdY * sdZ)
## Transformed matrices obtained by multivariate Delta method
##############################################################
### For mean vector
####################
func0Y <- matrix(c(1, mean0Y[4], 0, 0,
                   0, 0.5, 0.5, 0,
                   0, -0.5, 0.5, 0,
                   0, 0, 0, 1), nrow = 4, byrow = T)
func0Z <- matrix(c(1, mean0Z[4], 0, 0,
                   0, 0.5, 0.5, 0,
                   0, -0.5, 0.5, 0,
                   0, 0, 0, 1), nrow = 4, byrow = T)

### For var-cov matrix
#######################
grad0Y <- matrix(c(1, mean0Y[4], 0, mean0Y[2],
                   0, 0.5, 0.5, 0, 
                   0, -0.5, 0.5, 0,
                   0, 0, 0, 1), nrow = 4, byrow = T)
grad0Z <- matrix(c(1, mean0Z[4], 0, mean0Z[2],
                   0, 0.5, 0.5, 0, 
                   0, -0.5, 0.5, 0,
                   0, 0, 0, 1), nrow = 4, byrow = T)

grad0 <- cbind(rbind(grad0Y, matrix(0, nrow = 4, ncol = 4)), 
               rbind(matrix(0, nrow = 4, ncol = 4), grad0Z))

mean0.s <- c(func0Y[1:3, 1:3] %*% mean0Y[1:3], func0Z[1:3, 1:3] %*% mean0Z[1:3])
psi0.s <- grad0 %*% psi0 %*% t(grad0)
true.s <- c(mean0.s[1:3], mean0Y[4], mean0.s[4:6], mean0Z[4], psi0.s[row(psi0.s) >= col(psi0.s)])

init <- c(true.s, sdY, sdZ, 0.3 * sdY * sdZ) * runif(length(true.s) + 3, 0.9, 1.1)

## Main function to estimate a fixed knot 
##########################################
### Define manifested variables
manifests <- c(paste0("Y", 1:p), paste0("Z", 1:p))
### Define latent variables: growth factors for Reading and Math IRT trajectories
latents <- c("eta0sY", "eta1sY", "eta2sY", "deltaY", "eta0sZ", "eta1sZ", "eta2sZ", "deltaZ")
outDef <- list(); outLoadsY1 <- outLoadsY2 <- outLoadsY3 <- outLoadsZ1 <- outLoadsZ2 <- outLoadsZ3 <- list()
for(i in 1:p){
  outDef[[i]] <- mxMatrix("Full", 1, 1, free = F, labels = paste0("data.T", i), name = paste0("t", i))
  outLoadsY1[[i]] <- mxAlgebraFromString(paste0("t", i, " - mugY"), name = paste0("L1", i, "Y"))
  outLoadsY2[[i]] <- mxAlgebraFromString(paste0("abs(t", i, " - mugY)"), name = paste0("L2", i, "Y"))
  outLoadsY3[[i]] <- mxAlgebraFromString(paste0("-mueta2sY * (t", i, " - mugY)/abs(t", i, 
                                                " - mugY) - mueta2sY"), name = paste0("L3", i, "Y"))
  outLoadsZ1[[i]] <- mxAlgebraFromString(paste0("t", i, " - mugZ"), name = paste0("L1", i, "Z"))
  outLoadsZ2[[i]] <- mxAlgebraFromString(paste0("abs(t", i, " - mugZ)"), name = paste0("L2", i, "Z"))
  outLoadsZ3[[i]] <- mxAlgebraFromString(paste0("-mueta2sZ * (t", i, " - mugZ)/abs(t", i, 
                                                " - mugZ) - mueta2sZ"), name = paste0("L3", i, "Z"))
}
### Create a mxModel object
model_mx <- mxModel("Bivariate Nonlinear Growth Model with Random Knots", type = "RAM",
                    manifestVars = manifests, latentVars = latents,
                    mxData(observed = dat, type = "raw"),
                    #### Define factor loadings from latent variables to manifests
                    mxPath(from = "eta0sY", to = manifests[1:p], arrows = 1, free = F, values = 1),
                    mxPath(from = "eta1sY", to = manifests[1:p], arrows = 1, free = F, values = 0,
                           labels = paste0("L1", 1:p, "Y", "[1,1]")),
                    mxPath(from = "eta2sY", to = manifests[1:p], arrows = 1, free = F, values = 0,
                           labels = paste0("L2", 1:p, "Y", "[1,1]")),
                    mxPath(from = "deltaY", to = manifests[1:p], arrows = 1, free = F, values = 0,
                           labels = paste0("L3", 1:p, "Y", "[1,1]")),
                    mxPath(from = "eta0sZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 1),
                    mxPath(from = "eta1sZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                           labels = paste0("L1", 1:p, "Z", "[1,1]")),
                    mxPath(from = "eta2sZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                           labels = paste0("L2", 1:p, "Z", "[1,1]")),
                    mxPath(from = "deltaZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                           labels = paste0("L3", 1:p, "Z", "[1,1]")),
                    #### Define the variances of residuals
                    mxPath(from = manifests[1:p], to = manifests[1:p], 
                           arrows = 2, free = T, values = init[45],
                           labels = "residualsY"),
                    mxPath(from = manifests[(p + 1):(2 * p)], to = manifests[(p + 1):(2 * p)], 
                           arrows = 2, free = T, values = init[46],
                           labels = "residualsZ"),
                    #### Define the covariances of residuals
                    mxPath(from = manifests[1:p], to = manifests[(p + 1):(2 * p)], 
                           arrows = 2, free = T, values = init[47],
                           labels = "residualsYZ"),
                    #### Define means of latent variables
                    mxPath(from = "one", to = latents[c(1:3, 5:7)], arrows = 1, free = T, values = init[c(1:3, 5:7)],
                           labels = c("mueta0sY", "mueta1sY", "mueta2sY",
                                      "mueta0sZ", "mueta1sZ", "mueta2sZ")),
                    #### Define var-cov matrix of latent variables
                    mxPath(from = latents, to = latents, arrows = 2, connect = "unique.pairs", 
                           free = T, values = init[c(9:44)],
                           labels = c("psi0sY0sY", "psi0sY1sY", "psi0sY2sY", "psi0sYgY", "psi0sY0sZ", "psi0sY1sZ", "psi0sY2sZ", "psi0sYgZ",
                                      "psi1sY1sY", "psi1sY2sY", "psi1sYgY", "psi1sY0sZ", "psi1sY1sZ", "psi1sY2sZ", "psi1sYgZ",
                                      "psi2sY2sY", "psi2sYgY", "psi2sY0sZ", "psi2sY1sZ", "psi2sY2sZ", "psi2sYgZ",
                                      "psigYgY", "psigY0sZ", "psigY1sZ", "psigY2sZ", "psigYgZ",
                                      "psi0sZ0sZ", "psi0sZ1sZ", "psi0sZ2sZ", "psi0sZgZ",
                                      "psi1sZ1sZ", "psi1sZ2sZ", "psi1sZgZ",
                                      "psi2sZ2sZ", "psi2sZgZ",
                                      "psigZgZ")),
                    #### Add additional parameter and constraints
                    mxMatrix("Full", 1, 1, free = T, values = init[4], 
                             labels = "muknot_Y", name = "mugY"),
                    mxMatrix("Full", 1, 1, free = T, values = init[8], 
                             labels = "muknot_Z", name = "mugZ"),
                    outDef, outLoadsY1, outLoadsY2, outLoadsY3, outLoadsZ1, outLoadsZ2, outLoadsZ3, 
                    mxAlgebra(rbind(mueta0sY, mueta1sY, mueta2sY, mueta0sZ, mueta1sZ, mueta2sZ), name = "mean_s"),
                    
                    mxAlgebra(rbind(cbind(psi0sY0sY, psi0sY1sY, psi0sY2sY, psi0sYgY, psi0sY0sZ, psi0sY1sZ, psi0sY2sZ, psi0sYgZ),
                                    cbind(psi0sY1sY, psi1sY1sY, psi1sY2sY, psi1sYgY, psi1sY0sZ, psi1sY1sZ, psi1sY2sZ, psi1sYgZ),
                                    cbind(psi0sY2sY, psi1sY2sY, psi2sY2sY, psi2sYgY, psi2sY0sZ, psi2sY1sZ, psi2sY2sZ, psi2sYgZ),
                                    cbind(psi0sYgY, psi1sYgY, psi2sYgY, psigYgY, psigY0sZ, psigY1sZ, psigY1sZ, psigYgZ),
                                    cbind(psi0sY0sZ, psi1sY0sZ, psi2sY0sZ, psigY0sZ, psi0sZ0sZ, psi0sZ1sZ, psi0sZ2sZ, psi0sZgZ),
                                    cbind(psi0sY1sZ, psi1sY1sZ, psi2sY1sZ, psigY1sZ, psi0sZ1sZ, psi1sZ1sZ, psi1sZ2sZ, psi1sZgZ),
                                    cbind(psi0sY2sZ, psi1sY2sZ, psi2sY2sZ, psigY2sZ, psi0sZ2sZ, psi1sZ2sZ, psi2sZ2sZ, psi2sZgZ),
                                    cbind(psi0sYgZ, psi1sYgZ, psi2sYgZ, psigYgZ, psi0sZgZ, psi1sZgZ, psi2sZgZ, psigZgZ)), name = "psi_s"),
                    
                    mxAlgebra(rbind(cbind(1, -mugY, mugY, 0, 0, 0),
                                    cbind(0, 1, -1, 0, 0, 0),
                                    cbind(0, 1, 1, 0, 0, 0),
                                    cbind(0, 0, 0, 1, -mugZ, mugZ),
                                    cbind(0, 0, 0, 0, 1, -1),
                                    cbind(0, 0, 0, 0, 1, 1)), name = "func"),
                    
                    mxAlgebra(rbind(cbind(1, -mugY, mugY, 0, 0, 0, 0, 0),
                                    cbind(0, 1, -1, 0, 0, 0, 0, 0),
                                    cbind(0, 1, 1, 0, 0, 0, 0, 0),
                                    cbind(0, 0, 0, 1, 0, 0, 0, 0),
                                    cbind(0, 0, 0, 0, 1, -mugZ, mugZ, 0),
                                    cbind(0, 0, 0, 0, 0, 1, -1, 0),
                                    cbind(0, 0, 0, 0, 0, 1, 1, 0),
                                    cbind(0, 0, 0, 0, 0, 0, 0, 1)), name = "grad"),
                    mxAlgebra(func %*% mean_s, name = "mean"),
                    mxAlgebra(grad %*% psi_s %*% t(grad), name = "psi"))
model0 <- mxTryHard(model_mx, extraTries = 9,
                    initialGradientIterations = 20, OKstatuscodes = 0)
model <- mxRun(model0)

paraRandom <- c("mueta0Y", "mueta1Y", "mueta2Y", "mugY", "mueta0Z", "mueta1Z", "mueta2Z", "mugZ",
                paste0("psi", c("0Y0Y", "0Y1Y", "0Y2Y", "0YgY", "0Y0Z", "0Y1Z", "0Y2Z", "0YgZ",
                                "1Y1Y", "1Y2Y", "1YgY", "1Y0Z", "1Y1Z", "1Y2Z", "1YgZ", 
                                "2Y2Y", "2YgY", "2Y0Z", "2Y1Z", "2Y2Z", "2YgZ", 
                                "gYgY", "gY0Z", "gY1Z", "gY2Z", "gYgZ",
                                "0Z0Z", "0Z1Z", "0Z2Z", "0ZgZ",
                                "1Z1Z", "1Z2Z", "1ZgZ",
                                "2Z2Z", "2ZgZ",
                                "gZgZ")),
                "residualsY", "residualsZ", "residualsYZ")

model.para <- summary(model)$parameters[, c(1, 5, 6)]
model.est <- c(model$mean$result[1:3], model.para[model.para$name == "muknot_Y", 2],
               model$mean$result[4:6], model.para[model.para$name == "muknot_Z", 2],
               model$psi$result[row(model$psi$result) >= col(model$psi$result)], 
               model.para[c(1, 3, 2), 2])
mean.se <- mxSE(mean, model)
psi.se <- mxSE(psi, model)
model.se <- c(mean.se[1:3], model.para[model.para$name == "muknot_Y", 3], 
              mean.se[4:6], model.para[model.para$name == "muknot_Z", 3],
              psi.se[row(psi.se) >= col(psi.se)], model.para[c(1, 3, 2), 3])
out0 <- data.frame(Name = paraRandom, Estimate = model.est, SE = model.se)
out0$true <- true
out <- out0[c(1:8, 9, 17, 24, 30, 35, 39, 42, 44, 13, 21, 28, 34), ]


