## Required libraries
#####################
Sys.setenv(OMP_NUM_THREADS = parallel::detectCores() - 1)
library(OpenMx)

## Full Mixture of Experts Model with Time-varying expert covariates 
#####################################################################
getMoEVarying <- function(dat, c, p, init, beta, extratry = extratry, loop = loop){
  ### Define manifested variables
  manifests <- c(paste0("X", 1:p), paste0("M", 1:p))
  ### Define latent variables
  latents <- c("eta0s", "eta1s", "eta2s")
  outDef <- list(); outLoads1 <- list(); outLoads2 <- list()
  class.list <- list()
  for (k in 1:c){
    for(i in 1:p){
      outDef[[i]] <- mxMatrix("Full", 1, 1, free = F, labels = paste0("data.T", i), 
                              name = paste0("t", i))
      outLoads1[[i]] <- mxAlgebraFromString(paste0("t", i, " -c", k, "mug"), name = paste0("c", k, "L1", i))
      outLoads2[[i]] <- mxAlgebraFromString(paste0("abs(t", i, " -c", k, "mug)"), 
                                            name = paste0("c", k, "L2", i))
    }
    ### Create a mxModel object
    class.list[[k]] <- mxModel(name = paste0("Class", k), type = "RAM", 
                               manifestVars = manifests, latentVars = latents,
                               #### Define factor loadings from latent variables to manifests
                               mxPath(from = "eta0s", to = manifests[(p + 1):(p * 2)], arrows = 1, free = F, values = 1),
                               mxPath(from = "eta1s", to = manifests[(p + 1):(p * 2)], arrows = 1, free = F, values = 0,
                                      labels = paste0("c", k, "L1", 1:p, "[1,1]")),
                               mxPath(from = "eta2s", to = manifests[(p + 1):(p * 2)], arrows = 1, free = F, values = 0, 
                                      labels = paste0("c", k, "L2", 1:p, "[1,1]")),
                               #### Define the variances of residuals
                               mxPath(from = manifests[(p + 1):(p * 2)], to = manifests[(p + 1):(p * 2)], arrows = 2, free = T,
                                      values = init[[k]][11], labels = paste0("c", k, "residuals")),
                               #### Define means of latent variables
                               mxPath(from = "one", to = latents[1:3], arrows = 1, free = T, values = init[[k]][1:3],
                                      labels = paste0("c", k, c("mueta0s", "mueta1s", "mueta2s"))),
                               #### Define var-cov matrix of latent variables
                               mxPath(from = latents, to = latents, arrows = 2,
                                      connect = "unique.pairs", free = T,
                                      values = init[[k]][c(5:10)],
                                      labels = paste0("c", k, c("psi0s0s", "psi0s1s", "psi0s2s", 
                                                                "psi1s1s", "psi1s2s", "psi2s2s"))),
                               #### Add additional parameter and constraints
                               mxMatrix("Full", 1, 1, free = T, values = init[[k]][4], 
                                        labels = paste0("c", k, "muknot"), name = paste0("c", k, "mug")),
                               
                               #### Time-varying covariates
                               ##### Means
                               mxPath(from = "one", to = manifests[1:p], arrows = 1, free = TRUE, values = init[[k]][12], 
                                      labels = paste0("c", k, "tau", 1:p)),
                               ##### Variances
                               mxPath(from = manifests[1:p], to = manifests[1:p], arrows = 2, free = TRUE, values = init[[k]][13], 
                                      labels = paste0("c", k, "phi", 1:p, 1:p)),
                               ##### Effect of time-varying covariates
                               mxPath(from = manifests[1:p], to = manifests[(p + 1):(p * 2)], arrows = 1, free = TRUE, 
                                      values = init[[k]][14], labels = paste0("c", k, "beta")),
                               
                               
                               outDef, outLoads1, outLoads2, 
                               mxAlgebraFromString(paste0("rbind(c", k, "mueta0s, c", k, "mueta1s, c", k, "mueta2s)"), 
                                                   name = paste0("c", k, "mean_s")),
                               mxAlgebraFromString(paste0("rbind(cbind(c", k, "psi0s0s, c", k, "psi0s1s, c", k, "psi0s2s),",
                                                          "cbind(c", k, "psi0s1s, c", k, "psi1s1s, c", k, "psi1s2s),",
                                                          "cbind(c", k, "psi0s2s, c", k, "psi1s2s, c", k, "psi2s2s))"), 
                                                   name = paste0("c", k, "psi_s")),
                               mxAlgebraFromString(paste0("rbind(cbind(", "1,", "-c", k, "muknot,", "c", k, "muknot),",
                                                          "cbind(0, 1, -1), cbind(0, 1, 1))"),
                                                   name = paste0("c", k, "func")),
                               mxAlgebraFromString(paste0("rbind(cbind(", "1,", "-c", k, "muknot,", "c", k, "muknot),",
                                                          "cbind(0, 1, -1), cbind(0, 1, 1))"),
                                                   name = paste0("c", k, "grad")),
                               mxAlgebraFromString(paste0("c", k, "func %*% c", k, "mean_s"), name = paste0("c", k, "mean")),
                               mxAlgebraFromString(paste0("c", k, "grad %*% c", k, "psi_s %*% t(c", k, "grad)"), 
                                                   name = paste0("c", k, "psi")),
                               mxFitFunctionML(vector = T))
  }
  ### Make the class proportion matrix, fixing one parameter at a non-zero constant (one)
  classBeta <- mxMatrix(type = "Full", nrow = c, ncol = dim(beta)[2],
                        free = rep(c(F, rep(T, c - 1)), 5), values = beta,
                        labels = paste0("beta", rep(1:c), rep(0:4, each = c)), 
                        name = "classbeta")
  classPV <- mxMatrix(nrow = 5, ncol = 1, labels = c(NA, "data.INCOME", "data.EDU", "data.SEX", "data.RACE2"), 
                      values = 1, name = "weightsV")
  classP <- mxAlgebra(classbeta %*% weightsV, name = "weights")
  algebraObjective <- mxExpectationMixture(paste0("Class", 1:c), 
                                           weights = "weights", scale = "softmax")
  objective <- mxFitFunctionML()
  GMM_mx <- mxModel("Gating Network Mixture of Experts Model, Fixed Knots", 
                    mxData(observed = dat, type = "raw"), class.list, classBeta,
                    classPV, classP, algebraObjective, objective)
  model0 <- mxTryHard(GMM_mx, extraTries = extratry, 
                      initialGradientIterations = loop, OKstatuscodes = 0)
  #model <- mxRun(model0)
  return(model0)
}

getEstimation_Varying <- function(model, paraNames){
  model.para <- summary(model)$parameters[, c(1, 5, 6)]
  ### Estimates of parameters in each latent class
  model.est <- model.se <- est <- list()
  for (k in 1:c){
    model.est[[k]] <- c(mxEvalByName(paste0("c", k, "mean"), model = model@submodels[[k]]),
                        model.para[model.para$name == paste0("c", k, "muknot"), 2],
                        mxEvalByName(paste0("c", k, "psi"), model = model@submodels[[k]])[
                          row(mxEvalByName(paste0("c", k, "psi"), model = model@submodels[[k]])) >= 
                            col(mxEvalByName(paste0("c", k, "psi"), model = model@submodels[[k]]))],
                        model.para[model.para$name == paste0("c", k, "residuals"), 2],
                        model.para[model.para$name %in% paste0("c", k, "tau", 1:9), 2],
                        model.para[model.para$name %in% paste0("c", k, "phi", 1:9, 1:9), 2],
                        model.para[model.para$name == paste0("c", k, "beta"), 2])
    model.se[[k]] <- c(mxSE(paste0("Class", k, ".c", k, "mean"), model, forceName = T), 
                       model.para[model.para$name == paste0("c", k, "muknot"), 3],
                       mxSE(paste0("Class", k, ".c", k, "psi"), model, forceName = T)[
                         row(mxSE(paste0("Class", k, ".c", k, "psi"), model, forceName = T)) >=
                           col(mxSE(paste0("Class", k, ".c", k, "psi"), model, forceName = T))],
                       model.para[model.para$name == paste0("c", k, "residuals"), 3],
                       model.para[model.para$name %in% paste0("c", k, "tau", 1:9), 3],
                       model.para[model.para$name %in% paste0("c", k, "phi", 1:9, 1:9), 3],
                       model.para[model.para$name == paste0("c", k, "beta"), 3])
    est[[k]] <- data.frame(Name = paste0("c", k, paraNames),
                           Estimate = model.est[[k]], SE = model.se[[k]])
    
  }
  est.beta <- data.frame(Name = paste0("beta", rep(2:c, 3), rep(0:4, each = c - 1)), 
                         Estimate = c(mxEval(classbeta, model)[-1, ]),
                         SE = c(mxSE(classbeta, model)[-1, ]))
  estimates <- rbind(do.call(rbind.data.frame, est), est.beta)
  return(estimates)
}