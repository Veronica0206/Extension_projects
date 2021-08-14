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
psi0Y <- psi0Z <- matrix(c(25, 1.5, 1.5,
                           1.5, 1.0, 0.3,
                           1.5, 0.3, 1.0), nrow = 3)
psi0Y0Z <- matrix(c(7.5, 1.5, 1.5,
                    1.5, 0.3, 0.3,
                    1.5, 0.3, 0.3), nrow = 3)

psi0 <- cbind(rbind(psi0Y, psi0Y0Z), rbind(psi0Y0Z, psi0Z))
sdY <- sdZ <- 1

true <- c(mean0Y, mean0Z, psi0[row(psi0) >= col(psi0)], sdY, sdZ, 0.3 * sdY * sdZ)

## Transformed matrices obtained by multivariate Delta method
##############################################################
### For mean vector
####################
func0Y <- matrix(c(1, mean0Y[4], 0,
                   0, 0.5, 0.5,
                   0, -0.5, 0.5), nrow = 3, byrow = T)

func0Z <- matrix(c(1, mean0Z[4], 0,
                   0, 0.5, 0.5,
                   0, -0.5, 0.5), nrow = 3, byrow = T)

### For var-cov matrix
#######################
grad0Y <- matrix(c(1, mean0Y[4], 0,
                   0, 0.5, 0.5,
                   0, -0.5, 0.5), nrow = 3, byrow = T)

grad0Z <- matrix(c(1, mean0Z[4], 0,
                   0, 0.5, 0.5,
                   0, -0.5, 0.5), nrow = 3, byrow = T)

grad0 <- cbind(rbind(grad0Y, matrix(0, nrow = 3, ncol = 3)), 
               rbind(matrix(0, nrow = 3, ncol = 3), grad0Z))

mean0.s <- c(func0Y %*% mean0Y[1:3], func0Z%*% mean0Z[1:3])
psi0.s <- grad0 %*% psi0 %*% t(grad0)
true.s <- c(mean0.s[1:3], mean0Y[4], mean0.s[4:6], mean0Z[4], psi0.s[row(psi0.s) >= col(psi0.s)])

init <- c(true.s, sdY, sdZ, 0.3 * sdY * sdZ) * runif(length(true.s) + 3, 0.9, 1.1)

## Main function to estimate a fixed knot 
##########################################
### Define manifested variables
manifests <- c(paste0("Y", 1:p), paste0("Z", 1:p))
### Define latent variables
### Define latent variables: growth factors for Reading and Math IRT trajectories
latents <- c("eta0sY", "eta1sY", "eta2sY", "eta0sZ", "eta1sZ", "eta2sZ")
outDef <- list(); outLoadsY1 <- outLoadsY2 <- outLoadsZ1 <- outLoadsZ2 <- list()
for(i in 1:p){
  outDef[[i]] <- mxMatrix("Full", 1, 1, free = F, labels = paste0("data.T", i), name = paste0("t", i))
  outLoadsY1[[i]] <- mxAlgebraFromString(paste0("t", i, " - mugY"), name = paste0("L1", i, "Y"))
  outLoadsY2[[i]] <- mxAlgebraFromString(paste0("abs(t", i, " - mugY)"), name = paste0("L2", i, "Y"))
  outLoadsZ1[[i]] <- mxAlgebraFromString(paste0("t", i, " - mugZ"), name = paste0("L1", i, "Z"))
  outLoadsZ2[[i]] <- mxAlgebraFromString(paste0("abs(t", i, " - mugZ)"), name = paste0("L2", i, "Z"))
}
### Create a mxModel object
model_mx <- mxModel("Bivariate Nonlinear Growth Model with Fixed Knots", type = "RAM",
                    manifestVars = manifests, latentVars = latents,
                    mxData(observed = dat, type = "raw"),
                    #### Define factor loadings from latent variables to manifests
                    mxPath(from = "eta0sY", to = manifests[1:p], arrows = 1, free = F, values = 1),
                    mxPath(from = "eta1sY", to = manifests[1:p], arrows = 1, free = F, values = 0,
                           labels = paste0("L1", 1:p, "Y", "[1,1]")),
                    mxPath(from = "eta2sY", to = manifests[1:p], arrows = 1, free = F, values = 0,
                           labels = paste0("L2", 1:p, "Y", "[1,1]")),
                    mxPath(from = "eta0sZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 1),
                    mxPath(from = "eta1sZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                           labels = paste0("L1", 1:p, "Z", "[1,1]")),
                    mxPath(from = "eta2sZ", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                           labels = paste0("L2", 1:p, "Z", "[1,1]")),
                    #### Define the variances of residuals
                    mxPath(from = manifests[1:p], to = manifests[1:p], 
                           arrows = 2, free = T, values = init[30],
                           labels = "residualsY"),
                    mxPath(from = manifests[(p + 1):(2 * p)], to = manifests[(p + 1):(2 * p)], 
                           arrows = 2, free = T, values = init[31],
                           labels = "residualsZ"),
                    #### Define the covariances of residuals
                    mxPath(from = manifests[1:p], to = manifests[(p + 1):(2 * p)], 
                           arrows = 2, free = T, values = init[32],
                           labels = "residualsYZ"),
                    #### Define means of latent variables
                    mxPath(from = "one", to = latents, arrows = 1, free = T, values = init[c(1:3, 5:7)],
                           labels = c("mueta0sY", "mueta1sY", "mueta2sY",
                                      "mueta0sZ", "mueta1sZ", "mueta2sZ")),
                    #### Define var-cov matrix of latent variables
                    mxPath(from = latents, to = latents, arrows = 2, connect = "unique.pairs", 
                           free = T, values = init[c(9:29)],
                           labels = c("psi0sY0sY", "psi0sY1sY", "psi0sY2sY", "psi0sY0sZ", "psi0sY1sZ", "psi0sY2sZ", 
                                      "psi1sY1sY", "psi1sY2sY", "psi1sY0sZ", "psi1sY1sZ", "psi1sY2sZ",
                                      "psi2sY2sY", "psi2sY0sZ", "psi2sY1sZ", "psi2sY2sZ",
                                      "psi0sZ0sZ", "psi0sZ1sZ", "psi0sZ2sZ",
                                      "psi1sZ1sZ", "psi1sZ2sZ",
                                      "psi2sZ2sZ")),
                    #### Add additional parameter and constraints
                    mxMatrix("Full", 1, 1, free = T, values = init[4], 
                             labels = "muknot_Y", name = "mugY"),
                    mxMatrix("Full", 1, 1, free = T, values = init[8], 
                             labels = "muknot_Z", name = "mugZ"),
                    outDef, outLoadsY1, outLoadsY2, outLoadsZ1, outLoadsZ2,
                    mxAlgebra(rbind(mueta0sY, mueta1sY, mueta2sY, mueta0sZ, mueta1sZ, mueta2sZ), name = "mean_s"),
                    
                    mxAlgebra(rbind(cbind(psi0sY0sY, psi0sY1sY, psi0sY2sY, psi0sY0sZ, psi0sY1sZ, psi0sY2sZ),
                                    cbind(psi0sY1sY, psi1sY1sY, psi1sY2sY, psi1sY0sZ, psi1sY1sZ, psi1sY2sZ),
                                    cbind(psi0sY2sY, psi1sY2sY, psi2sY2sY, psi2sY0sZ, psi2sY1sZ, psi2sY2sZ),
                                    cbind(psi0sY0sZ, psi1sY0sZ, psi2sY0sZ, psi0sZ0sZ, psi0sZ1sZ, psi0sZ2sZ),
                                    cbind(psi0sY1sZ, psi1sY1sZ, psi2sY1sZ, psi0sZ1sZ, psi1sZ1sZ, psi1sZ2sZ),
                                    cbind(psi0sY2sZ, psi1sY2sZ, psi2sY2sZ, psi0sZ2sZ, psi1sZ2sZ, psi2sZ2sZ)), name = "psi_s"),
                    
                    mxAlgebra(rbind(cbind(1, -mugY, mugY, 0, 0, 0),
                                    cbind(0, 1, -1, 0, 0, 0),
                                    cbind(0, 1, 1, 0, 0, 0),
                                    cbind(0, 0, 0, 1, -mugZ, mugZ),
                                    cbind(0, 0, 0, 0, 1, -1),
                                    cbind(0, 0, 0, 0, 1, 1)), name = "func"),
                    
                    mxAlgebra(rbind(cbind(1, -mugY, mugY, 0, 0, 0),
                                    cbind(0, 1, -1, 0, 0, 0),
                                    cbind(0, 1, 1, 0, 0, 0),
                                    cbind(0, 0, 0, 1, -mugZ, mugZ),
                                    cbind(0, 0, 0, 0, 1, -1),
                                    cbind(0, 0, 0, 0, 1, 1)), name = "grad"),
                    mxAlgebra(func %*% mean_s, name = "mean"),
                    mxAlgebra(grad %*% psi_s %*% t(grad), name = "psi"))
model0 <- mxTryHard(model_mx, extraTries = 9,
                    initialGradientIterations = 20, OKstatuscodes = 0)
model <- mxRun(model0)

paraFixed <- c("mueta0Y", "mueta1Y", "mueta2Y", "mugY", "mueta0Z", "mueta1Z", "mueta2Z", "mugZ",
               paste0("psi", c("0Y0Y", "0Y1Y", "0Y2Y", "0Y0Z", "0Y1Z", "0Y2Z",
                               "1Y1Y", "1Y2Y", "1Y0Z", "1Y1Z", "1Y2Z",
                               "2Y2Y", "2Y0Z", "2Y1Z", "2Y2Z",
                               "0Z0Z", "0Z1Z", "0Z2Z",
                               "1Z1Z", "1Z2Z",
                               "2Z2Z")),
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
out0 <- data.frame(Name = paraFixed, Estimate = model.est, SE = model.se)
out0$true <- true
out <- out0[c(1:8, 9, 15, 20, 24, 27, 29, 12, 18, 23), ]

