Growth Mixture Model to Investigate Heterogeneity in Nonlinear Joint
Development with Individual Measurement Occasions
================
Jin Liu
2021/11/21

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

## Growth Mixture Model Featuring with Multiple Growth Model with Bilinear Spline Functional Form

### Read in dataset for analyses (wide-format data)

``` r
load("Bi_BLS_dat2.RData")
```

### Specify parameters need to be print out

``` r
paraBLS_PLGCM.r <- c(
  "Y_mueta0", "Y_mueta1", "Y_mueta2", "Y_knot",
  paste0("Y_psi", c("00", "01", "02", "11", "12", "22")), "Y_res",
  "Z_mueta0", "Z_mueta1", "Z_mueta2", "Z_knot",
  paste0("Z_psi", c("00", "01", "02", "11", "12", "22")), "Z_res",
  paste0("YZ_psi", c(c("00", "10", "20", "01", "11", "21", "02", "12", "22"))),"YZ_res"
  )
```

### Fit the model

``` r
GMM_MGM_BLS_out <- getMIX(dat = Bi_BLS_dat2, prop_starts = c(0.45, 0.55), sub_Model = "MGM", cluster_TIC = c("gx1", "gx2"), t_var = c("T", "T"), 
                          records = list(1:10, 1:10), y_var = c("Y", "Z"), curveFun = "BLS", intrinsic = FALSE, y_model = "LGCM", 
                          res_scale = list(c(0.25, 0.25), c(0.25, 0.25)), res_cor = list(0.3, 0.3), tries = 10, paramOut = TRUE, names = "paraBLS_PLGCM.r")
```

    ## # weights:  4 (3 variable)
    ## initial  value 346.573590 
    ## final  value 312.978442 
    ## converged
    ## 

### Visulize longitudinal outcomes

``` r
xstarts <- mean(Bi_BLS_dat2$T1)
Figure1 <- getFigure(
  model = GMM_MGM_BLS_out@mxOutput, nClass = 2, cluster_TIC = c("gx1", "gx2"), sub_Model = "MGM", y_var = c("Y", "Z"), curveFun = "BLS", y_model = "LGCM", 
  t_var = c("T", "T"), records = list(1:10, 1:10), m_var = NULL, x_var = NULL, x_type = NULL, xstarts = xstarts, xlab = c("Time", "Time"), 
  outcome = c("OutcomeY", "OutcomeZ")
)
```

    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character
    ## Treating first argument as an object that stores a character

``` r
show(Figure1)
```

    ## figOutput Object
    ## --------------------
    ## Trajectories: 2 
    ## 
    ## Trajectory 1 :
    ##   Figure 1:

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](OpenMx_demo3_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

    ## 
    ## Trajectory 2 :
    ##   Figure 1:

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](OpenMx_demo3_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->
