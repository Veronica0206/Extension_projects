Extending Mixture of Experts Model to Investigate Heterogeneity of
Trajectories
================
Jin Liu
2021/11/21

## Require package would be used

``` r
library(OpenMx)
```

    ## OpenMx may run faster if it is compiled to take advantage of multiple cores.

``` r
library(tidyr)
library(ggplot2)
```

## OS, R version and OpenMx Version

``` r
mxOption(model = NULL, key = "Default optimizer", "CSOLNP", reset = FALSE)
mxVersion()
```

    ## OpenMx version: 2.19.6 [GIT v2.19.6]
    ## R version: R version 4.1.0 (2021-05-18)
    ## Platform: x86_64-apple-darwin17.0 
    ## MacOS: 12.0.1
    ## Default optimizer: CSOLNP
    ## NPSOL-enabled?: No
    ## OpenMP-enabled?: No

## “True” values of parameters

``` r
### Class 1
#### Population values of growth factor means
# meanY0 <- c(100, 4.2, 1.8, 3.5)
### Population values of growth factor var-cov matrix
# psiY0 <- matrix(c(25, 1.5, 1.5, 
#                   1.5, 1.0, 0.3, 
#                   1.5, 0.3, 1.0), nrow = 3)
#### Population values of TIC means
# meanX0 <- c(0, 0)
### Population values of growth factor var-cov matrix
# phi0 <- matrix(c(1, 0.3, 0.3, 1), nrow = 2)
#### Population values of path coefficients
# betaXtoY <- matrix(c(1.251505, 1.877258,
#                      0.250301, 0.3754515,
#                      0.250301, 0.3754515), byrow = T, nrow = 3)
### Population values of unexplained var-cov matrix
# psiY0 - betaXtoY %*% phi0 %*% t(betaXtoY) is
# matrix(c(18.5, 0.20000002, 0.20000002, 
#          0.2, 0.74000005, 0.04000005,
#          0.2, 0.04000005, 0.74000005), byrow = T, nrow = 3)
### Class 2
#### Population values of growth factor means
# meanY0 <- c(100, 5.0, 2.6, 5.5)
#### Population values of growth factor var-cov matrix
# psiY0 <- matrix(c(25, 1.5, 1.5, 
#                   1.5, 1.0, 0.3, 
#                   1.5, 0.3, 1.0), nrow = 3)
#### Population values of TIC means
# meanX0 <- c(0, 0)
#### Population values of growth factor var-cov matrix
# phi0 <- matrix(c(1, 0.3, 0.3, 1), nrow = 2)
#### Population values of path coefficients
# betaXtoY <- matrix(c(1.251505, 1.877258,
#                      0.250301, 0.3754515,
#                      0.250301, 0.3754515), byrow = T, nrow = 3)
### Population values of unexplained var-cov matrix
# psiY0 - betaXtoY %*% phi0 %*% t(betaXtoY) is
# matrix(c(18.5, 0.20000002, 0.20000002, 
#          0.2, 0.74000005, 0.04000005,
#          0.2, 0.04000005, 0.74000005), byrow = T, nrow = 3)
### Population values of logistic coefficients
# beta0 <- 0; beta1 <- log(1.5); beta2 <- log(1.7)
```

## Define Parameter lists

``` r
### Bilinear spline with a fixed knot
paraFixed <- c("mueta0", "mueta1", "mueta2", "mug",
               paste0("psi", c("00", "01", "02", "11", "12", "22")),
               "residuals")

### Bilinear spline with a fixed knot and two baseline covariates
paraFixedTIC <- c("mueta0", "mueta1", "mueta2", "mug",
                  paste0("psi", c("00", "01", "02", "11", "12", "22")),
                  paste0("beta1", 0:2), paste0("beta2", 0:2),
                  paste0("mux", 1:2), paste0("phi", c("11", "12", "22")),
                  "residuals")
```

## Read in dataset for analyses (wide-format data)

``` r
load("BLSGM_uni_sub_dat.RData")
```

## Summarize data

``` r
summary(BLSGM_uni_sub_dat)
```

    ##        id              Y1               Y2               Y3        
    ##  Min.   :  1.0   Min.   : 85.13   Min.   : 87.99   Min.   : 92.78  
    ##  1st Qu.:125.8   1st Qu.: 96.44   1st Qu.:100.83   1st Qu.:105.25  
    ##  Median :250.5   Median : 99.57   Median :104.53   Median :108.83  
    ##  Mean   :250.5   Mean   : 99.83   Mean   :104.52   Mean   :109.01  
    ##  3rd Qu.:375.2   3rd Qu.:103.05   3rd Qu.:108.33   3rd Qu.:113.18  
    ##  Max.   :500.0   Max.   :114.42   Max.   :119.72   Max.   :125.87  
    ##        Y4               Y5               Y6               Y7        
    ##  Min.   : 95.45   Min.   : 97.53   Min.   : 95.97   Min.   : 97.13  
    ##  1st Qu.:109.33   1st Qu.:112.71   1st Qu.:115.27   1st Qu.:117.14  
    ##  Median :113.73   Median :117.74   Median :121.14   Median :124.34  
    ##  Mean   :113.64   Mean   :117.63   Mean   :121.09   Mean   :124.09  
    ##  3rd Qu.:118.34   3rd Qu.:122.73   3rd Qu.:127.18   3rd Qu.:131.07  
    ##  Max.   :131.27   Max.   :138.07   Max.   :143.94   Max.   :150.38  
    ##        Y8               Y9              Y10               T1   
    ##  Min.   : 95.72   Min.   : 93.61   Min.   : 93.04   Min.   :0  
    ##  1st Qu.:118.98   1st Qu.:120.30   1st Qu.:122.13   1st Qu.:0  
    ##  Median :126.46   Median :128.88   Median :130.77   Median :0  
    ##  Mean   :126.23   Mean   :128.46   Mean   :130.70   Mean   :0  
    ##  3rd Qu.:133.59   3rd Qu.:136.52   3rd Qu.:139.12   3rd Qu.:0  
    ##  Max.   :154.20   Max.   :161.88   Max.   :163.97   Max.   :0  
    ##        T2               T3              T4              T5       
    ##  Min.   :0.7504   Min.   :1.751   Min.   :2.750   Min.   :3.750  
    ##  1st Qu.:0.8655   1st Qu.:1.849   1st Qu.:2.875   1st Qu.:3.872  
    ##  Median :0.9927   Median :1.982   Median :2.993   Median :3.984  
    ##  Mean   :0.9971   Mean   :1.989   Mean   :2.995   Mean   :3.994  
    ##  3rd Qu.:1.1270   3rd Qu.:2.134   3rd Qu.:3.117   3rd Qu.:4.124  
    ##  Max.   :1.2493   Max.   :2.249   Max.   :3.250   Max.   :4.250  
    ##        T6              T7              T8              T9             T10   
    ##  Min.   :4.750   Min.   :5.752   Min.   :6.751   Min.   :7.751   Min.   :9  
    ##  1st Qu.:4.869   1st Qu.:5.881   1st Qu.:6.872   1st Qu.:7.874   1st Qu.:9  
    ##  Median :4.992   Median :6.015   Median :6.996   Median :8.001   Median :9  
    ##  Mean   :4.995   Mean   :6.013   Mean   :6.993   Mean   :7.998   Mean   :9  
    ##  3rd Qu.:5.121   3rd Qu.:6.140   3rd Qu.:7.112   3rd Qu.:8.128   3rd Qu.:9  
    ##  Max.   :5.250   Max.   :6.250   Max.   :7.250   Max.   :8.249   Max.   :9  
    ##       gx1                 gx2                ex1                 ex2          
    ##  Min.   :-3.260176   Min.   :-2.92854   Min.   :-2.793868   Min.   :-2.81088  
    ##  1st Qu.:-0.716653   1st Qu.:-0.67691   1st Qu.:-0.697995   1st Qu.:-0.66148  
    ##  Median :-0.009174   Median :-0.07856   Median : 0.002327   Median :-0.01852  
    ##  Mean   :-0.001558   Mean   :-0.04389   Mean   :-0.027127   Mean   :-0.01231  
    ##  3rd Qu.: 0.754089   3rd Qu.: 0.56556   3rd Qu.: 0.697397   3rd Qu.: 0.61436  
    ##  Max.   : 2.949655   Max.   : 3.08296   Max.   : 2.630130   Max.   : 3.06419  
    ##     subgroup    
    ##  Min.   :1.000  
    ##  1st Qu.:1.000  
    ##  Median :2.000  
    ##  Mean   :1.528  
    ##  3rd Qu.:2.000  
    ##  Max.   :2.000

## Visualize data

``` r
long_dat_T <- gather(BLSGM_uni_sub_dat, var.T, time, T1:T10)
long_dat_Y <- gather(BLSGM_uni_sub_dat, var.Y, measures, Y1:Y10)
long_dat <- data.frame(id = long_dat_T[, "id"], time = long_dat_T[, "time"],
                       measures = long_dat_Y[, "measures"], class = long_dat_Y[, "subgroup"])
ggplot(aes(x = time, y = measures), data = long_dat) +
  geom_line(aes(group = id), color = "lightgrey", data = long_dat) +
  geom_point(aes(group = id), color = "darkgrey", size = 0.5) +
  geom_smooth(aes(group = 1), size = 1.8, col = "lightblue", se = F, 
              data = long_dat[long_dat$class == 1, ] ) + 
  geom_smooth(aes(group = 1), size = 1.8, col = "pink", se = F, 
              data = long_dat[long_dat$class == 2, ] ) + 
  labs(title = "Nonlinear Pattern with Individually Varying Measurement Time",
       x ="Time", y = "Measurement") + 
  theme(plot.title = element_text(hjust = 0.5))
```

    ## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
    ## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'

![](OpenMx_demo_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## Load functions that help calculate initial values

``` r
source("getPosterior.R")
source("BLSGM_fixed.R")
source("BLSGM_TIC_fixed.R")
```

## Finite Mixture Model

``` r
source("FMM_BLSGM.R")
FMM_BLSGM <- getFMM_BLSGM(dat = BLSGM_uni_sub_dat, T_records = 1:10, nClass = 2, traj_var = "Y", t_var = "T", paraNames = paraFixed)
FMM_BLSGM[[2]]
```

    ##           Name Estimate     SE
    ## 1     c1mueta0  99.4925 0.3522
    ## 2     c1mueta1   4.1595 0.0860
    ## 3     c1mueta2   1.7857 0.0980
    ## 4        c1mug   3.4622 0.0345
    ## 5      c1psi00  22.3972 2.2583
    ## 6      c1psi01   1.2029 0.3850
    ## 7      c1psi02   1.4059 0.4087
    ## 8      c1psi11   1.2167 0.1290
    ## 9      c1psi12   0.3894 0.0985
    ## 10     c1psi22   1.1032 0.1435
    ## 11 c1residuals   1.0539 0.0403
    ## 12    c2mueta0 100.2121 0.3213
    ## 13    c2mueta1   4.9826 0.0830
    ## 14    c2mueta2   2.6243 0.0731
    ## 15       c2mug   5.4911 0.0313
    ## 16     c2psi00  21.9494 2.0362
    ## 17     c2psi01   1.1625 0.3471
    ## 18     c2psi02   1.1668 0.3315
    ## 19     c2psi11   0.9551 0.1172
    ## 20     c2psi12   0.3032 0.0738
    ## 21     c2psi22   1.0143 0.1012
    ## 22 c2residuals   0.9333 0.0351
    ## 23          p2   1.1295 0.1260

## Cluter Predictor Mixture model (Gating-network Mixture of Experts)

``` r
source("CPMM_BLSGM.R")
CPMM_BLSGM <- getCPMM_BLSGM(dat = BLSGM_uni_sub_dat, T_records = 1:10, nClass = 2, traj_var = "Y", t_var = "T", clus_cov = c("gx1", "gx2"),
                            paraNames = paraFixed)
```

    ## # weights:  4 (3 variable)
    ## initial  value 346.573590 
    ## final  value 308.656901 
    ## converged

``` r
CPMM_BLSGM[[2]]
```

    ##           Name Estimate     SE
    ## 1     c1mueta0  99.4507 0.3522
    ## 2     c1mueta1   4.1814 0.0846
    ## 3     c1mueta2   1.8077 0.0963
    ## 4        c1mug   3.4613 0.0342
    ## 5      c1psi00  22.7075 2.2762
    ## 6      c1psi01   1.3560 0.3872
    ## 7      c1psi02   1.4414 0.4241
    ## 8      c1psi11   1.2026 0.1267
    ## 9      c1psi12   0.4258 0.0991
    ## 10     c1psi22   1.1703 0.1481
    ## 11 c1residuals   1.0451 0.0397
    ## 12    c2mueta0 100.2456 0.3180
    ## 13    c2mueta1   4.9683 0.0795
    ## 14    c2mueta2   2.6052 0.0728
    ## 15       c2mug   5.4921 0.0311
    ## 16     c2psi00  21.5985 2.0053
    ## 17     c2psi01   1.0222 0.3442
    ## 18     c2psi02   1.1114 0.3283
    ## 19     c2psi11   0.9912 0.1154
    ## 20     c2psi12   0.3078 0.0735
    ## 21     c2psi22   0.9901 0.0994
    ## 22 c2residuals   0.9376 0.0349
    ## 23      beta20   0.1805 0.1383
    ## 24      beta21   0.6103 0.1249
    ## 25      beta22   0.6117 0.1278

## Growth Predictor Mixture model (Expert-network Mixture of Experts)

``` r
source("GPMM_BLSGM.R")
GPMM_BLSGM <- getGPMM_BLSGM(dat = BLSGM_uni_sub_dat, T_records = 1:10, nClass = 2, traj_var = "Y", t_var = "T", growth_cov = c("ex1", "ex2"),
                            paraNames = paraFixedTIC)
GPMM_BLSGM[[2]]
```

    ##           Name Estimate     SE
    ## 1     c1mueta0  99.5555 0.3129
    ## 2     c1mueta1   4.1428 0.0726
    ## 3     c1mueta2   1.8418 0.0827
    ## 4        c1mug   3.4630 0.0347
    ## 5      c1psi00  18.2952 1.8111
    ## 6      c1psi01   0.0822 0.2925
    ## 7      c1psi02   0.3537 0.3236
    ## 8      c1psi11   0.8820 0.0953
    ## 9      c1psi12   0.0804 0.0703
    ## 10     c1psi22   0.8836 0.1090
    ## 11    c1beta10   0.9563 0.3162
    ## 12    c1beta11   0.2230 0.0716
    ## 13    c1beta12   0.3180 0.0749
    ## 14    c1beta20   1.5800 0.3432
    ## 15    c1beta21   0.4647 0.0762
    ## 16    c1beta22   0.3349 0.0816
    ## 17      c1mux1  -0.0498 0.0733
    ## 18      c1mux2   0.0066 0.0696
    ## 19     c1phi11   1.0302 0.0996
    ## 20     c1phi12   0.3252 0.0733
    ## 21     c1phi22   0.9087 0.0926
    ## 22 c1residuals   1.0694 0.0394
    ## 23    c2mueta0 100.2687 0.2876
    ## 24    c2mueta1   5.0386 0.0751
    ## 25    c2mueta2   2.6231 0.0672
    ## 26       c2mug   5.4871 0.0308
    ## 27     c2psi00  16.2207 1.5586
    ## 28     c2psi01   0.2597 0.2896
    ## 29     c2psi02   0.1955 0.2619
    ## 30     c2psi11   0.7498 0.0981
    ## 31     c2psi12   0.1544 0.0618
    ## 32     c2psi22   0.8113 0.0835
    ## 33    c2beta10   1.2371 0.2810
    ## 34    c2beta11   0.2463 0.0706
    ## 35    c2beta12   0.2050 0.0643
    ## 36    c2beta20   1.8363 0.2933
    ## 37    c2beta21   0.2490 0.0703
    ## 38    c2beta22   0.3417 0.0649
    ## 39      c2mux1  -0.0061 0.0683
    ## 40      c2mux2  -0.0299 0.0683
    ## 41     c2phi11   0.9741 0.0911
    ## 42     c2phi12   0.1964 0.0687
    ## 43     c2phi22   0.9624 0.0932
    ## 44 c2residuals   0.9229 0.0341
    ## 45          p2   1.0721 0.1187

## Full Mixture Model (Full Mixture of Experts)

``` r
source("FullMM_BLSGM.R")
FullMM_BLSGM <- getFullMM_BLSGM(dat = BLSGM_uni_sub_dat, T_records = 1:10, nClass = 2, traj_var = "Y", t_var = "T", growth_cov = c("ex1", "ex2"),
                                clus_cov = c("gx1", "gx2"), paraNames = paraFixedTIC)
```

    ## # weights:  4 (3 variable)
    ## initial  value 346.573590 
    ## final  value 308.656901 
    ## converged

``` r
FullMM_BLSGM[[2]]
```

    ##           Name Estimate     SE
    ## 1     c1mueta0  99.5189 0.3095
    ## 2     c1mueta1   4.1627 0.0751
    ## 3     c1mueta2   1.8637 0.0816
    ## 4        c1mug   3.4620 0.0344
    ## 5      c1psi00  18.5109 1.8151
    ## 6      c1psi01   0.1724 0.2918
    ## 7      c1psi02   0.3483 0.3225
    ## 8      c1psi11   0.8560 0.0956
    ## 9      c1psi12   0.0997 0.0707
    ## 10     c1psi22   0.9329 0.1094
    ## 11    c1beta10   0.9422 0.3159
    ## 12    c1beta11   0.2326 0.0742
    ## 13    c1beta12   0.2985 0.0777
    ## 14    c1beta20   1.6254 0.3389
    ## 15    c1beta21   0.4711 0.0763
    ## 16    c1beta22   0.3851 0.0832
    ## 17      c1mux1  -0.0583 0.0753
    ## 18      c1mux2   0.0298 0.0706
    ## 19     c1phi11   1.0182 0.1000
    ## 20     c1phi12   0.3205 0.0757
    ## 21     c1phi22   0.9111 0.0938
    ## 22 c1residuals   1.0611 0.0402
    ## 23    c2mueta0 100.3010 0.2826
    ## 24    c2mueta1   5.0257 0.0834
    ## 25    c2mueta2   2.6054 0.0671
    ## 26       c2mug   5.4886 0.0308
    ## 27     c2psi00  15.9513 1.5311
    ## 28     c2psi01   0.1656 0.2885
    ## 29     c2psi02   0.1838 0.2573
    ## 30     c2psi11   0.8005 0.1179
    ## 31     c2psi12   0.1651 0.0632
    ## 32     c2psi22   0.8010 0.0830
    ## 33    c2beta10   1.2332 0.2776
    ## 34    c2beta11   0.2234 0.0778
    ## 35    c2beta12   0.2066 0.0640
    ## 36    c2beta20   1.8129 0.2931
    ## 37    c2beta21   0.2696 0.0768
    ## 38    c2beta22   0.3263 0.0660
    ## 39      c2mux1   0.0022 0.0708
    ## 40      c2mux2  -0.0519 0.0701
    ## 41     c2phi11   0.9842 0.0935
    ## 42     c2phi12   0.2017 0.0729
    ## 43     c2phi22   0.9578 0.0954
    ## 44 c2residuals   0.9263 0.0353
    ## 45      beta20   0.1018 0.1408
    ## 46      beta21   0.6539 0.1245
    ## 47      beta22   0.5782 0.1249
