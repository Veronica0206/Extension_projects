JB_RM_init <- c(33.9563410, -38.5699971, -184.8547392, -1.4468095, 20.2687964, -180.4655313, -690.5947509, -0.5228315, #### Mean vector
                237.5897086, -46.7415598, 220.0783360, 136.9706829, 140.3250453, 566.8988806, 
                1824.2229111, 2746.9048183, 148.2818391, 1692.2281131, 4593.3210011, 
                4646.4016072, 84.5678283, 2884.6231519, 8287.5268413, 
                123.9547445, -56.1066102, -19.2815243,
                7298.2595589, 19247.3897666, 
                51832.6762876,
                46.1045619, 32.0430924, 5.8863230)
init <- list()
init[[1]] <- init[[2]] <- JB_RM_init

Beta <- matrix(c(0, 0, 0, 0, log(1.5), log(1.7)), byrow = T, nrow = 2)
beta <- Beta * runif(dim(Beta)[2], 0.9, 1.1)

p <- 10; c <- 2
## Required libraries
#####################
Sys.setenv(OMP_NUM_THREADS = parallel::detectCores() - 1)
library(OpenMx)
######################################################################
####################    Start here in practice    ####################
######################################################################

## Main function for GMM with joint development
################################################
### Define manifested variables
manifests <- c(paste0("Y", 1:10), paste0("Z", 1:10))
### Define latent variables: growth factors for Reading and Math IRT trajectories
latents <- c("eta0Y", "eta1Y", "eta2Y", "eta0Z", "eta1Z", "eta2Z")
outDef <- outLoads1 <- outLoads2Y <- outLoads2Z <- list()
class.list <- list()
for(k in 1:c){
  for(i in 1:p){
    outDef[[i]] <- mxMatrix("Full", 1, 1, free = F, labels = paste0("data.T", i), 
                            name = paste0("t", i))
    outLoads1[[i]] <- mxAlgebraFromString(paste0("t", i), name = paste0("c", k, "L1", i))
    outLoads2Y[[i]] <- mxAlgebraFromString(paste0("exp(c", k, "gammaY * t", i, ") - 1"),
                                           name = paste0("c", k, "L2", i, "Y"))
    outLoads2Z[[i]] <- mxAlgebraFromString(paste0("exp(c", k, "gammaZ * t", i, ") - 1"),
                                           name = paste0("c", k, "L2", i, "Z"))
  }
  ### Create a mxModel object
  class.list[[k]] <- mxModel(name = paste0("Class", k), type = "RAM",
                             manifestVars = manifests, latentVars = latents,
                             mxData(observed = dat, type = "raw"),
                             #### Define factor loadings from latent variables to manifests
                             mxPath(from = "eta0Y", to = manifests[1:p], arrows = 1, free = F, values = 1),
                             mxPath(from = "eta1Y", to = manifests[1:p], arrows = 1, free = F, values = 0,
                                    labels = paste0("c", k, "L1", 1:p, "[1,1]")),
                             mxPath(from = "eta2Y", to = manifests[1:p], arrows = 1, free = F, values = 0, 
                                    labels = paste0("c", k, "L2", 1:p, "Y[1,1]")),
                             mxPath(from = "eta0Z", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 1),
                             mxPath(from = "eta1Z", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                                    labels = paste0("c", k, "L1", 1:p, "[1,1]")),
                             mxPath(from = "eta2Z", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0, 
                                    labels = paste0("c", k, "L2", 1:p, "Z[1,1]")),
                             #### Define the variances of residuals
                             mxPath(from = manifests[1:p], to = manifests[1:p], 
                                    arrows = 2, free = T, values = init[[k]][30],
                                    labels = paste0("c", k, "residualsY")),
                             mxPath(from = manifests[(p + 1):(2 * p)], to = manifests[(p + 1):(2 * p)], 
                                    arrows = 2, free = T, values = init[[k]][31],
                                    labels = paste0("c", k, "residualsZ")),
                             
                             #### Define the covariance of residuals
                             mxPath(from = manifests[1:p], to = manifests[(p + 1):(2 * p)], 
                                    arrows = 2, free = T, values = init[[k]][32],
                                    labels = paste0("c", k, "residualsYZ")),
                             
                             #### Define means of latent variables
                             mxPath(from = "one", to = latents, arrows = 1, free = T, values = init[[k]][c(1:3, 5:7)],
                                    labels = paste0("c", k, c("mueta0Y", "mueta1Y", "mueta2Y", "mueta0Z", "mueta1Z", "mueta2Z"))),
                             #### Define var-cov matrix of latent variables
                             mxPath(from = latents, to = latents, arrows = 2,
                                    connect = "unique.pairs", free = T,
                                    values = init[[k]][c(9:29)],
                                    labels = paste0("c", k, c("psi0Y0Y", "psi0Y1Y", "psi0Y2Y", "psi0Y0Z", "psi0Y1Z", "psi0Y2Z",
                                                              "psi1Y1Y", "psi1Y2Y", "psi1Y0Z", "psi1Y1Z", "psi1Y2Z",
                                                              "psi2Y2Y", "psi2Y0Z", "psi2Y1Z", "psi2Y2Z",
                                                              "psi0Z0Z", "psi0Z1Z", "psi0Z2Z",
                                                              "psi1Z1Z", "psi1Z2Z",
                                                              "psi2Z2Z"))),
                             #### Add additional parameter and constraints
                             mxMatrix("Full", 1, 1, free = T, values = init[[k]][4], 
                                      labels = paste0("c", k, "gammaY"), name = paste0("c", k, "mucurY")),
                             mxMatrix("Full", 1, 1, free = T, values = init[[k]][8], 
                                      labels = paste0("c", k, "gammaZ"), name = paste0("c", k, "mucurZ")),
                             outDef, outLoads1, outLoads2Y, outLoads2Z,
                             mxFitFunctionML(vector = T))
}
### Make the class proportion matrix, fixing one parameter at a non-zero constant (one)
classBeta <- mxMatrix(type = "Full", nrow = c, ncol = dim(beta)[2],
                      free = rep(c(F, rep(T, c - 1)), 3), values = beta,
                      labels = paste0("beta", rep(1:c), rep(0:2, each = c)), 
                      name = "classbeta")
classPV <- mxMatrix(nrow = 3, ncol = 1, labels = c(NA, "data.x1", "data.x2"), 
                    values = 1, name = "weightsV")
classP <- mxAlgebra(classbeta %*% weightsV, name = "weights")
algebraObjective <- mxExpectationMixture(paste0("Class", 1:c), 
                                         weights = "weights", scale = "softmax")
objective <- mxFitFunctionML()
GMM_mx <- mxModel("GMM for nonlinear joint development, Jenss Bayley", 
                  mxData(observed = dat, type = "raw"), 
                  class.list, classBeta, classPV, classP, algebraObjective, objective)
model0 <- mxTryHard(GMM_mx, extraTries = 9, loc = 1, scale = 0.05, 
                    initialGradientIterations = 20, OKstatuscodes = 0)
model <- mxRun(model0)

