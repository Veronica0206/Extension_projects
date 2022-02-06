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
outDef <- list(); outLoads1 <- outLoads2 <- list()
class.list <- list()
for(k in 1:c){
  for(i in 1:p){
    outDef[[i]] <- mxMatrix("Full", 1, 1, free = F, labels = paste0("data.T", i), name = paste0("t", i))
    outLoads1[[i]] <- mxAlgebraFromString(paste0("t", i), name = paste0("c", k, "L1", i))
    outLoads2[[i]] <- mxAlgebraFromString(paste0("t", i, "^2"), name = paste0("c", k, "L2", i))
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
                                    labels = paste0("c", k, "L2", 1:p, "[1,1]")),
                             
                             mxPath(from = "eta0Z", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 1),
                             mxPath(from = "eta1Z", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0,
                                    labels = paste0("c", k, "L1", 1:p, "[1,1]")),
                             mxPath(from = "eta2Z", to = manifests[(p + 1):(2 * p)], arrows = 1, free = F, values = 0, 
                                    labels = paste0("c", k, "L2", 1:p, "[1,1]")),
                             
                             #### Define the variances of residuals
                             mxPath(from = manifests[1:p], to = manifests[1:p], 
                                    arrows = 2, free = T, values = init[[k]][28],
                                    labels = paste0("c", k, "residualsY")),
                             mxPath(from = manifests[(p + 1):(2 * p)], to = manifests[(p + 1):(2 * p)], 
                                    arrows = 2, free = T, values = init[[k]][29],
                                    labels = paste0("c", k, "residualsZ")),
                             
                             #### Define the covariance of residuals
                             mxPath(from = manifests[1:p], to = manifests[(p + 1):(2 * p)], 
                                    arrows = 2, free = T, values = init[[k]][30],
                                    labels = paste0("c", k, "residualsYZ")),
                             
                             #### Define means of latent variables
                             mxPath(from = "one", to = latents, arrows = 1, free = T, values = init[[k]][1:6],
                                    labels = paste0("c", k, c("mueta0Y", "mueta1Y", "mueta2Y", 
                                                              "mueta0Z", "mueta1Z", "mueta2Z"))),
                             
                             #### Define var-cov matrix of latent variables
                             mxPath(from = latents, to = latents, arrows = 2,
                                    connect = "unique.pairs", free = T,
                                    values = init[[k]][c(7:27)],
                                    labels = paste0("c", k, c("psi0Y0Y", "psi0Y1Y", "psi0Y2Y", "psi0Y0Z", "psi0Y1Z", "psi0Y2Z",
                                                              "psi1Y1Y", "psi1Y2Y", "psi1Y0Z", "psi1Y1Z", "psi1Y2Z",
                                                              "psi2Y2Y", "psi2Y0Z", "psi2Y1Z", "psi2Y2Z",
                                                              "psi0Z0Z", "psi0Z1Z", "psi0Z2Z",
                                                              "psi1Z1Z", "psi1Z2Z",
                                                              "psi2Z2Z"))),
                             #### Add additional parameter and constraints
                             outDef, outLoads1, outLoads2,
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
GMM_mx <- mxModel("GMM for nonlinear joint development, fixed knots", 
                  mxData(observed = dat, type = "raw"), 
                  class.list, classBeta, classPV, classP, algebraObjective, objective)
model0 <- mxTryHard(GMM_mx, extraTries = 9, loc = 1, scale = 0.05, 
                    initialGradientIterations = 20, OKstatuscodes = 0)
model <- mxRun(model0)

