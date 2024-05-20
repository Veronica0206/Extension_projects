Mediational Processes in Parallel Bilinear Spline Growth Curve Models in
the Framework of Individual Measurement Occasions
================
Jin Liu

## OS, R version and OpenMx Version

``` r
library(nlpsem)
```

    ## Loading required package: OpenMx

    ## OpenMx may run faster if it is compiled to take advantage of multiple cores.

``` r
OpenMx::mxOption(model = NULL, key = "Default optimizer", "CSOLNP", reset = FALSE)
OpenMx::mxVersion()
```

    ## OpenMx version: 2.21.8 [GIT v2.21.8]
    ## R version: R version 4.2.2 (2022-10-31)
    ## Platform: aarch64-apple-darwin20 
    ## MacOS: 14.4.1
    ## Default optimizer: CSOLNP
    ## NPSOL-enabled?: No
    ## OpenMP-enabled?: No

## First Model: Baseline X to longitudinal M to longitudinal Y

### Read in dataset for analyses (wide-format data)

``` r
load("MED2_BLS_dat.RData")
```

## Specify parameters need to be print out

``` r
paraMed2_BLS <- c(
  "muX", "phi11", "alphaM1", "alphaMr", "alphaM2", "mugM",
  paste0("psi", c("M1M1", "M1Mr", "M1M2", "MrMr", "MrM2", "M2M2"), "_r"),
  "alphaY1", "alphaYr", "alphaY2", "mugY",
  paste0("psi", c("Y1Y1", "Y1Yr", "Y1Y2", "YrYr", "YrY2", "Y2Y2"), "_r"),
  paste0("beta", rep(c("M", "Y"), each = 3), rep(c(1, "r", 2), 2)),
  paste0("beta", c("M1Y1", "M1Yr", "M1Y2", "MrYr", "MrY2", "M2Y2")),
  "muetaM1", "muetaMr", "muetaM2", "muetaY1", "muetaYr", "muetaY2", 
  paste0("Mediator", c("11", "1r", "12", "rr", "r2", "22")),
  paste0("total", c("1", "r", "2")),
  "residualsM", "residualsY", "residualsYM"
  )
```

### Fit the model

``` r
Med2_LGCM_BLS <- getMediation(dat = MED2_BLS_dat, t_var = rep("T", 2), y_var = "Y", m_var = "M", x_type = "baseline", x_var = "X", curveFun = "bilinear spline", 
                              records = list(1:9, 1:9), res_scale = c(0.1, 0.1), res_cor = 0.3, paramOut = TRUE, names = paraMed2_BLS)
```

## Second Model: Longitudinal X to longitudinal M to longitudinal Y

### Read in dataset for analyses (wide-format data)

``` r
load("MED3_BLS_dat.RData")
```

## Specify parameters need to be print out

``` r
paraMed3_BLS <- c(
  "muetaX1", "muetaXr", "muetaX2", "mugX",
  paste0("psi", c("X1X1", "X1Xr", "X1X2", "XrXr", "XrX2", "X2X2")),
  "alphaM1", "alphaMr", "alphaM2", "mugM",
  paste0("psi", c("M1M1", "M1Mr", "M1M2", "MrMr", "MrM2", "M2M2"), "_r"),
  "alphaY1", "alphaYr", "alphaY2", "mugY",
  paste0("psi", c("Y1Y1", "Y1Yr", "Y1Y2", "YrYr", "YrY2", "Y2Y2"), "_r"),
  paste0("beta", c("X1Y1", "X1Yr", "X1Y2", "XrYr", "XrY2", "X2Y2",
                   "X1M1", "X1Mr", "X1M2", "XrMr", "XrM2", "X2M2",
                   "M1Y1", "M1Yr", "M1Y2", "MrYr", "MrY2", "M2Y2")),
  "muetaM1", "muetaMr", "muetaM2", "muetaY1", "muetaYr", "muetaY2",
  paste0("mediator", c("111", "11r", "112", "1rr", "1r2",
                       "122", "rr2", "r22", "rrr", "222")),
  paste0("total", c("11", "1r", "12", "rr", "r2", "22")),
  "residualsX", "residualsM", "residualsY", "residualsMX", "residualsYX", "residualsYM"
  )
```

### Fit the model

``` r
Med3_LGCM_BLS <- getMediation(dat = MED3_BLS_dat, t_var = rep("T", 3), y_var = "Y", m_var = "M", x_type = "longitudinal", x_var = "X", curveFun = "BLS", 
                              records = list(1:10, 1:10, 1:10), res_scale = c(0.1, 0.1, 0.1), res_cor = c(0.3, 0.3), tries = 10, paramOut = TRUE,
                              names = paraMed3_BLS
  )
```
