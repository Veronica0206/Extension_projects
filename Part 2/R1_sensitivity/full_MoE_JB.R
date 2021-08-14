# For using MoE with Jenss-Bayley functional form, we still need to specify initial values for class-specific parameters as well as
# logistic coefficients

## Required libraries
#####################
Sys.setenv(OMP_NUM_THREADS = parallel::detectCores() - 1)
library(OpenMx)

## Set the number of repeated measures and the number of experts
#################################################################
p <- 10; c <- 2

## Original parameter setting
##############################
c1_mean0 <- c(100.0, -5.0, 0, 1)
c2_mean0 <- c(100.0, -5.0, 0, 1)

c1_psi0 <- c2_psi0 <- matrix(c(25, 1.5, 1.5,
                               1.5, 1.0, 0.3,
                               1.5, 0.3, 1.0), nrow = 3)
sd1 <- sd2 <- 1
sd <- c(sd1, sd2)

c1_beta <- matrix(c(1.251505, 1.877258,
                    0.250301, 0.3754515,
                    0.250301, 0.3754515), nrow = 3, byrow = T)/sqrt(2)


c2_beta <- matrix(c(1.251505, 1.877258,
                    0.250301, 0.3754515,
                    0.250301, 0.3754515), nrow = 3, byrow = T)

c1_mean.x1 <- c1_mean.x2 <- c2_mean.x1 <- c2_mean.x2 <- 0
c1_phi <- c2_phi <- matrix(c(1, 0.3, 0.3, 1), nrow = 2, ncol = 2)
c1_sigma.yy <- c1_psi0
c1_sigma.xy <-  c1_beta %*% c1_phi
c1_sigma0 <- rbind(cbind(c1_sigma.yy, c1_sigma.xy), cbind(t(c1_sigma.xy), c1_phi))
c1_zeta <- c1_psi0 - c1_beta %*% c1_phi %*% t(c1_beta)
c1_true <- c(c1_mean0, c1_zeta[row(c1_zeta) >= col(c1_zeta)], c(c1_beta), sd1)

c2_mean.x1 <- c2_mean.x2 <- c2_mean.x1 <- c2_mean.x2 <- 0
c2_phi <- c2_phi <- matrix(c(1, 0.3, 0.3, 1), nrow = 2, ncol = 2)
c2_sigma.yy <- c2_psi0
c2_sigma.xy <-  c2_beta %*% c2_phi
c2_sigma0 <- rbind(cbind(c2_sigma.yy, c2_sigma.xy), cbind(t(c2_sigma.xy), c2_phi))
c2_zeta <- c2_psi0 - c2_beta %*% c2_phi %*% t(c2_beta)
c2_true <- c(c2_mean0, c2_zeta[row(c2_zeta) >= col(c2_zeta)], c(c2_beta), sd2)

c1_init <- c1_true * runif(length(c1_true), 0.9, 1.1)

c2_init <- c2_true * runif(length(c2_true), 0.9, 1.1)

init <- list(c1_init, c2_init)

Beta <- matrix(c(0, 0, 0, 0, log(1.5), log(1.7)), byrow = T, nrow = 2)
beta <- Beta * runif(dim(Beta)[2], 0.9, 1.1)

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
    outLoads2[[i]] <- mxAlgebraFromString(paste0("exp(c", k, "gamma * t", i, ") - 1"), 
                                          name = paste0("c", k, "L2", i))
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
                             mxPath(from = manifests, to = manifests, arrows = 2, free = T, values = init[[k]][17],
                                    labels = paste0("c", k, "residuals")),
                             #### Define means of latent variables
                             mxPath(from = "one", to = latents[1:3], arrows = 1, free = T, values = init[[k]][1:3],
                                    labels = c(paste0("c", k, c("mueta0", "mueta1", "mueta2")))),
                             #### Define var-cov matrix of latent variables
                             mxPath(from = latents, to = latents, arrows = 2,
                                    connect = "unique.pairs", free = T,
                                    values = init[[k]][c(5:10)],
                                    labels = c(paste0("c", k, c("psi00", "psi01", "psi02", 
                                                                "psi11", "psi12", "psi22")))),
                             #### Add additional parameter and constraints
                             mxMatrix("Full", 1, 1, free = T, values = init[[k]][4], 
                                      labels = paste0("c", k, "gamma"), name = paste0("c", k, "mucur")),
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
GMM_mx <- mxModel("Full Mixture of Experts Model, Jenss Bayley", 
                  mxData(observed = dat, type = "raw"), class.list, classBeta,
                  classPV, classP, algebraObjective, objective)
model0 <- mxTryHard(GMM_mx, extraTries = 9, 
                    initialGradientIterations = 20, OKstatuscodes = 0)
model <- mxRun(model0)
