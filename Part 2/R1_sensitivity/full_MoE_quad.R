# For using MoE with quadratic functional form, we still need to specify initial values for class-specific parameters as well as
# logistic coefficients

## Full Mixture of Experts Model
#################################
### Define manifested variables
manifests <- paste0("Y", 1:p)
### Define latent variables
latents <- c("eta0", "eta1", "eta2")
outDef <- outLoads1 <- outLoads2 <- list()
class.list <- list()
for (k in 1:c){
  for(i in 1:p){
    outDef[[i]] <- mxMatrix("Full", 1, 1, free = F, labels = paste0("data.T", i), 
                            name = paste0("t", i))
    outLoads1[[i]] <- mxAlgebraFromString(paste0("t", i), name = paste0("c", k, "L1", i))
    outLoads2[[i]] <- mxAlgebraFromString(paste0("t", i, "^2"), name = paste0("c", k, "L2", i))
  }
  ### Create a mxModel object
  class.list[[k]] <- mxModel(name = paste0("Class", k), type = "RAM",
                             manifestVars = c(manifests, "ex1", "ex2"), latentVars = latents,
                             #### Define factor loadings from latent variables to manifests
                             mxPath(from = "eta0", to = manifests, arrows = 1, free = F, values = 1),
                             mxPath(from = "eta1", to = manifests, arrows = 1, free = F, values = 0,
                                    labels = paste0("c", k, "L1", 1:p, "[1,1]")),
                             mxPath(from = "eta2", to = manifests, arrows = 1, free = F, values = 0, 
                                    labels = paste0("c", k, "L2", 1:p, "[1,1]")),
                             #### Define the variances of residuals
                             mxPath(from = manifests, to = manifests, arrows = 2, free = T, values = init[[k]][10],
                                    labels = paste0("c", k, "residuals")),
                             #### Define means of latent variables
                             mxPath(from = "one", to = latents[1:3], arrows = 1, free = T, values = init[[k]][1:3],
                                    labels = c(paste0("c", k, c("mueta0", "mueta1", "mueta2")))),
                             #### Define var-cov matrix of latent variables
                             mxPath(from = latents, to = latents, arrows = 2,
                                    connect = "unique.pairs", free = T,
                                    values = init[[k]][c(4:9)],
                                    labels = c(paste0("c", k, c("psi00", "psi01", "psi02", 
                                                                "psi11", "psi12", "psi22")))),
                             #### Include time-invariate covariates
                             ##### Means
                             mxPath(from = "one", to = c("ex1", "ex2"), arrows = 1, free = T, 
                                    values = c(0, 0), labels = paste0("c", k, "mux", 1:2)),
                             mxPath(from = c("ex1", "ex2"), to = c("ex1", "ex2"), connect = "unique.pairs", 
                                    arrows = 2, free = T,
                                    values = c(1, 0.3, 1), 
                                    labels = paste0("c", k, "phi", c("11", "12", "22"))),
                             ##### Regression coefficients
                             mxPath(from = "ex1", to = latents, arrows = 1, free = T, 
                                    values = init[[k]][11:13], labels = paste0("c", k, "beta1", 0:2)),
                             mxPath(from = "ex2", to = latents, arrows = 1, free = T, 
                                    values = init[[k]][14:16], labels = paste0("c", k, "beta2", 0:2)),
                             #### Add additional parameter and constraints
                             outDef, outLoads1, outLoads2, 
                             mxFitFunctionML(vector = T))
}

### Make the class proportion matrix, fixing one parameter at a non-zero constant (one)
classBeta <- mxMatrix(type = "Full", nrow = c, ncol = dim(beta)[2],
                      free = rep(c(F, rep(T, c - 1)), 3), values = beta,
                      labels = paste0("beta", rep(1:c), rep(0:2, each = c)), 
                      name = "classbeta")
classPV <- mxMatrix(nrow = 3, ncol = 1, labels = c(NA, "data.gx1", "data.gx2"), 
                    values = 1, name = "weightsV")
classP <- mxAlgebra(classbeta %*% weightsV, name = "weights")
algebraObjective <- mxExpectationMixture(paste0("Class", 1:c), 
                                         weights = "weights", scale = "softmax")
objective <- mxFitFunctionML()
GMM_mx <- mxModel("Full Mixture of Experts Model, Quadratic", 
                  mxData(observed = dat, type = "raw"), class.list, classBeta,
                  classPV, classP, algebraObjective, objective)
model0 <- mxTryHard(GMM_mx, extraTries = 9, 
                    initialGradientIterations = 20, OKstatuscodes = 0)
model <- mxRun(model0)
