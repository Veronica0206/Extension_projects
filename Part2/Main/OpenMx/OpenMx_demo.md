Extending Mixture of Experts Model to Investigate Heterogeneity of
Trajectories: When, Where and How to Add Which Covariates
================
Jin Liu

## Require package would be used

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

## Read in dataset for analyses (wide-format data)

``` r
load("BLS_dat2.RData")
```

## Specify parameters need to be print out

``` r
paraBLS.TIC_LGCM.r <- c("alpha0", "alpha1", "alpha2", "knot", paste0("psi", c("00", "01", "02", "11", "12", "22")), "residuals",
                        paste0("beta1", 0:2), paste0("beta2", 0:2), paste0("mux", 1:2), paste0("phi", c("11", "12", "22")),
                        "mueta0", "mueta1", "mueta2")

paraBLS_LGCM.r <- c("mueta0", "mueta1", "mueta2", "knot", paste0("psi", c("00", "01", "02", "11", "12", "22")), "residuals")
```

## First Model: Full Mixture Model with Bilinear Spline Functional Form

### Fit the model

``` r
Full_MIX_BLS_LGCM_out <-  getMIX(dat = BLS_dat2, prop_starts = c(0.45, 0.55), sub_Model = "LGCM", cluster_TIC = c("gx1", "gx2"), y_var = "Y", t_var = "T",
                                 records = 1:10, curveFun = "BLS", intrinsic = FALSE, res_scale = list(0.3, 0.3), growth_TIC = c("ex1", "ex2"), 
                                 paramOut = TRUE, names = paraBLS.TIC_LGCM.r)
```

    ## # weights:  4 (3 variable)
    ## initial  value 346.573590 
    ## final  value 342.101817 
    ## converged

### Visulize longitudinal outcomes

``` r
xstarts <- mean(BLS_dat2$T1)
Figure1 <- getFigure(
  model = Full_MIX_BLS_LGCM_out@mxOutput, nClass = 2, cluster_TIC = c("gx1", "gx2"), sub_Model = "LGCM", y_var = "Y", curveFun = "BLS", t_var = "T", records = 1:10,
  m_var = NULL, x_var = NULL, x_type = NULL, xstarts = xstarts, xlab = "Time", outcome = "Outcome"
)
```

    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character

``` r
show(Figure1)
```

    ## figOutput Object
    ## --------------------
    ## Trajectories: 1 
    ## Figure 1:

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](OpenMx_demo2_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

## Second Model: Growth Predictor Mixture Model with Bilinear Spline Functional Form

### Fit the model

``` r
Growth_MIX_BLS_LGCM_out <-  getMIX(dat = BLS_dat2, prop_starts = c(0.45, 0.55), sub_Model = "LGCM", cluster_TIC = NULL, y_var = "Y", t_var = "T",
                                   records = 1:10, curveFun = "BLS", intrinsic = FALSE, res_scale = list(0.3, 0.3), growth_TIC = c("ex1", "ex2"), 
                                   paramOut = TRUE, names = paraBLS.TIC_LGCM.r)
```

### Visulize longitudinal outcomes

``` r
xstarts <- mean(BLS_dat2$T1)
Figure2 <- getFigure(
  model = Growth_MIX_BLS_LGCM_out@mxOutput, nClass = 2, cluster_TIC = NULL, sub_Model = "LGCM", y_var = "Y", curveFun = "BLS", t_var = "T", records = 1:10,
  m_var = NULL, x_var = NULL, x_type = NULL, xstarts = xstarts, xlab = "Time", outcome = "Outcome"
)
```

    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character

``` r
show(Figure2)
```

    ## figOutput Object
    ## --------------------
    ## Trajectories: 1 
    ## Figure 1:

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](OpenMx_demo2_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## Third Model: Cluster Predictor Mixture Model with Bilinear Spline Functional Form

### Fit the model

``` r
Cluster_MIX_BLS_LGCM_out <-  getMIX(dat = BLS_dat2, prop_starts = c(0.45, 0.55), sub_Model = "LGCM", cluster_TIC = c("gx1", "gx2"), y_var = "Y", t_var = "T",
                                    records = 1:10, curveFun = "BLS", intrinsic = FALSE, res_scale = list(0.3, 0.3), growth_TIC = NULL, 
                                    paramOut = TRUE, names = paraBLS_LGCM.r)
```

    ## # weights:  4 (3 variable)
    ## initial  value 346.573590 
    ## final  value 342.101817 
    ## converged

### Visulize longitudinal outcomes

``` r
xstarts <- mean(BLS_dat2$T1)
Figure3 <- getFigure(
  model = Cluster_MIX_BLS_LGCM_out@mxOutput, nClass = 2, cluster_TIC = c("gx1", "gx2"), sub_Model = "LGCM", y_var = "Y", curveFun = "BLS", t_var = "T", records = 1:10,
  m_var = NULL, x_var = NULL, x_type = NULL, xstarts = xstarts, xlab = "Time", outcome = "Outcome"
)
```

    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character

``` r
show(Figure3)
```

    ## figOutput Object
    ## --------------------
    ## Trajectories: 1 
    ## Figure 1:

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](OpenMx_demo2_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

## Fourth Model: Finite Mixture Model Mixture Model with Bilinear Spline Functional Form

### Fit the model

``` r
Finite_MIX_BLS_LGCM_out <-  getMIX(dat = BLS_dat2, prop_starts = c(0.45, 0.55), sub_Model = "LGCM", cluster_TIC = NULL, y_var = "Y", t_var = "T",
                                   records = 1:10, curveFun = "BLS", intrinsic = FALSE, res_scale = list(0.3, 0.3), growth_TIC = NULL, 
                                   paramOut = TRUE, names = paraBLS_LGCM.r)
```

### Visulize longitudinal outcomes

``` r
xstarts <- mean(BLS_dat2$T1)
Figure4 <- getFigure(
  model = Finite_MIX_BLS_LGCM_out@mxOutput, nClass = 2, cluster_TIC = NULL, sub_Model = "LGCM", y_var = "Y", curveFun = "BLS", t_var = "T", records = 1:10,
  m_var = NULL, x_var = NULL, x_type = NULL, xstarts = xstarts, xlab = "Time", outcome = "Outcome"
)
```

    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character

``` r
show(Figure4)
```

    ## figOutput Object
    ## --------------------
    ## Trajectories: 1 
    ## Figure 1:

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](OpenMx_demo2_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->
