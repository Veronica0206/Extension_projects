# Extension projects

## Part I: Parallel Bilinear Spline Growth Models (PBLSGMs) in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Estimating Knots and Their Association in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions (***Psychological Methods*, 2021, [Advance online publication](https://doi.org/10.1037/met0000309)**)

**Description:** <br>
In this part, we developed two models in unstructured time framework:
- PBLSGMs for estimating fixed knots 
- PBLSGMs for estimating random knots

**Demo:**
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/OpenMx_E1/OpenMx_demo.md)
(For OS, R version, and OpenMx version, see the demo)

**Example data:** <br>
- [Data](https://github.com/Veronica0206/NonLinearCurve/blob/main/data/BLSGM_bi_dat.RData)

**Source Code:** <br>
***R package: OpenMx*** <br>
**The models developed in this project are now part of *R* package *NonLinearCurve* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [PBLSGMs for estimating fixed knots](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/PBLSGM_fixed.R)
- [PBLSGMs for estimating random knots](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/PBLSGM_random.R)

***MPlus 8*** <br>
- [PBLSGMs for estimating fixed knots](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/MPlus8_E1/PBLSGM_Unknown%20Fixed%20Knot.inp)
- [PBLSGMs for estimating random knots](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/MPlus8_E1/PBLSGM_Unknown%20Random%20Knot.inp)

## Part II: Extending Mixture of Experts Model to Investigate Heterogeneity of Trajectories
**Manuscript Title:** <br>
Extending Mixture of Experts Model to Investigate Heterogeneity of Trajectories: When, Where and How to Add Which Covariates (**accepted for publication in *Psychological Methods***)

**Description:** <br>
In this part, we extended Mixture-of-Experts Models to the SEM framework with individual measurement occasions:
- Full Mixture Model (Full mixture of experts)
- Growth Predictor Mixture Model (Expert-network mixture of experts)
- Cluster Predictor Mixture Model (Gating-network mixture of experts)
- Finite Mixture Model

**Demo:** 
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/OpenMx_E2/OpenMx_demo.md)
(For OS, R version, and OpenMx version, see the demo)

**Example data:** <br>
- [Data](https://github.com/Veronica0206/NonLinearCurve/blob/main/data/BLSGM_uni_sub_dat.RData)

**Source Code:** <br>
***R package: OpenMx*** <br>
**The models developed in this project are now part of *R* package *NonLinearCurve* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [Full Mixture Model (Full mixture of experts)](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/BLSGM_FullMM.R)
- [Growth Predictor Mixture Model (Expert-network mixture of experts)](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/BLSGM_GPMM.R)
- [Cluster Predictor Mixture Model (Gating-network mixture of experts)](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/BLSGM_CPMM.R)
- [Finite Mixture Model](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/BLSGM_FMM.R)

***MPlus 8*** <br>
- [Full Mixture Model (Full mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/Full%20MoE.inp)
- [Growth Predictor Mixture Model (Expert-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/Expert-network%20MoE.inp)
- [Cluster Predictor Mixture Model (Gating-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/Gating-network%20MoE.inp)
- [Finite Mixture Model](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/FMM.inp)

**In this part, we further extend the full mixture model to allow time-varying covariates and provide *OpenMx* code.**
- [Full mixture model with time-varying covariates](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_extension/fun_for_VaryingMoE.R)

**This project also provides *OpenMx* code with common parametric functional forms to capture nonlinear change patterns.**
- [Quadratic growth curve](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_sensitivity/full_MoE_quad.R)
- [Jenss-Bayley growth curve](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_sensitivity/full_MoE_JB.R)

## Part III: Growth Mixture Model to Investigate Heterogeneity in Nonlinear Joint Development with Individual Measurement Occasions
**Manuscript Title:** <br>
Extending Growth Mixture Model to Assess Heterogeneity in Joint Development with Piecewise Linear Trajectories in the Framework of Individual Measurement Occasions

**Description:** <br>
In this part, we extended Growth Mixture Models to investigate heterogeneity in nonlinear joint development with individual measurement occasions:
- PBLSGMM with fixed knots w/o cluster predictor
- PBLSGMM with fixed knots w/ cluster predictor

**Demo:** 
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%203/OpenMx_E3/OpenMx_demo.md)
(For OS, R version, and OpenMx version, see the demo)

**Example data:** <br>
- [Data](https://github.com/Veronica0206/NonLinearCurve/blob/main/data/BLSGM_bi_sub_dat.RData)

**Source Code:** <br>
***R package: OpenMx*** <br>
**The models developed in this project are now part of *R* package *NonLinearCurve* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [PBLSGMM with fixed knots w/o cluster predictor](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/PBLSGM_FMM.R)
- [PBLSGMM with fixed knots w/ cluster predictor](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/PBLSGM_CPMM.R)

***MPlus 8*** <br>
- [PBLSGMM with fixed knots w/ cluster predictor](https://github.com/Veronica0206/Extension_projects/blob/master/Part%203/MPlus8_E3/PBLSGMM.inp)

**This project also provides *OpenMx* code with common parametric functional forms to capture nonlinear change patterns.**
- [GMM with parallel quadratic growth curve](https://github.com/Veronica0206/Extension_projects/blob/master/Part%203/R1_sensitivity/GMM_parallel%20quad.R)
- [GMM with parallel Jenss-Bayley growth curve](https://github.com/Veronica0206/Extension_projects/blob/master/Part%203/R1_sensitivity/GMM_parallel_JB.R)

## Part VI: Mediational Processes in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Assessing Mediational Processes in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions.

**Description:** <br>
In this study, we extend latent growth mediation models with linear trajectories (Cheong et al., 2003) and develop two models to evaluate mediational processes where the bilinear spline (i.e., the linear-linear piecewise) growth model is utilized to capture the change patterns. We define the mediational process as either the baseline covariate or the change of covariate influencing the change of the mediator, which, in turn, affects the change of the outcome. 
- Baseline covariate->longitudinal mediator->longitudinal outcome
- Longitudinal covariate->longitudinal mediator->longitudinal outcome

**Demo:** 
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%206/OpenMx_demo6.md)
(For OS, R version, and OpenMx version, see the demo)

**Source Code:** <br>
Will upload later.


## Special instructions of repositories “Dissertation_projects” and “Extension_projects”:

**We developed multiple models in the six projects described in these two repositories. *R* functions for all developed models are now part of *R* package *[NonLinearCurve](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/)* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**<br>

**We provide a flow chart below to recommend when to use which model in this collection.**<br>

![](https://github.com/Veronica0206/Extension_projects/blob/master/plot.jpg)<!-- -->


