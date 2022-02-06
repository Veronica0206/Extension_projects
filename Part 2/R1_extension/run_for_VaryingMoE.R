extratry <- 10; loop <- 0; core <- 3
c <- 3; p <- 9
source("fun_for_VaryingMoE.R")

paraFixed <- c("mueta0", "mueta1", "mueta2", "mug",
               paste0("psi", c("00", "01", "02", "11", "12", "22")),
               "residuals", 
               paste0("tau", 1:p), paste0("phi", 1:p, 1:p), "beta")

math_TIC <- read.csv(file = "math_TIC.csv")[, -1]
head(math_TIC)

## Preprocess data
math_TIC$T1 <- math_TIC$T1 - 60
math_TIC$T2 <- math_TIC$T2 - 60
math_TIC$T3 <- math_TIC$T3 - 60
math_TIC$T4 <- math_TIC$T4 - 60
math_TIC$T5 <- math_TIC$T5 - 60
math_TIC$T6 <- math_TIC$T6 - 60
math_TIC$T7 <- math_TIC$T7 - 60
math_TIC$T8 <- math_TIC$T8 - 60
math_TIC$T9 <- math_TIC$T9 - 60

math_TIC$X1 <- scale(math_TIC$Approach_to_Learning1)
math_TIC$X2 <- scale(math_TIC$Approach_to_Learning2)
math_TIC$X3 <- scale(math_TIC$Approach_to_Learning3)
math_TIC$X4 <- scale(math_TIC$Approach_to_Learning4)
math_TIC$X5 <- scale(math_TIC$Approach_to_Learning5)
math_TIC$X6 <- scale(math_TIC$Approach_to_Learning6)
math_TIC$X7 <- scale(math_TIC$Approach_to_Learning7)
math_TIC$X8 <- scale(math_TIC$Approach_to_Learning8)
math_TIC$X9 <- scale(math_TIC$Approach_to_Learning9)

math_TIC$RACE2 <- ifelse(math_TIC$RACE == 1, 1, 2)

init1 <- c(58.67, 1.33, -0.47, 23.56, 
           93.86, 1.04, -1.41,
           0.03, -0.02, 
           0.05,
           27.96,
           -0.5, 1, 1)
init2 <- c(108.29, 1.14, -0.61, 49.12,
           110.13, 0.35, -0.85, 
           0.02, 0.01, 
           0.02,
           28.67,
           0, 1, 1)
init3 <- c(106.72, 1.39, -0.65, 36.23, 
           114.68, 0.05, -1.08,
           0.01, -0.01,
           0.02,
           34.06,
           0.5, 1, 1)

init.math3 <- list(init1, init2, init3)

log_Beta <- matrix(c(0, 1.72, -0.99, 
                     0, 0.09, 0.16,
                     0, 0.18, 0.44,
                     0, -1.08, -1.06, 
                     0, -0.55, -0.50), nrow = 3)
                     
ptm <- proc.time()
VaryingMoE_math3 <- try(getMoEVarying(dat = math_TIC, c = c, p = p, init = init.math3,
									  beta = log_Beta, extratry = extratry, loop = loop))
taken <- proc.time() - ptm
									 
VaryingOut <- getEstimation_Varying(model = VaryingMoE_math3, paraNames = paraFixed)

save.image("math3_varying.Rdata")
