# Extension projects

## Part I: Parallel Bilinear Spline Growth Models (PBLSGMs) in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Estimating Knots and Their Association in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions (***Psychological Methods*, 2021, [Advance online publication](https://doi.org/10.1037/met0000309)**)

**Description:** <br>
In this part, we developed two models in unstructured time framework:
- PBLSGMs for estimating fixed knots 
- PBLSGMs for estimating random knots

**Demo:**
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/OpenMx_demo1.md)
(For OS, R version, and OpenMx version, see the demo)

**Example data:** <br>
- [Data](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/example_data.csv)

**Source Code:** <br>
***R package: OpenMx*** <br>
- [PBLSGMs for estimating fixed knots](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/OpenMx_E1/PBLSGM_fixed.R)
- [PBLSGMs for estimating random knots](https://github.com/Veronica0206/Extension_projects/blob/master/Part%201/OpenMx_E1/PBLSGM_random.R)

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
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/OpenMx_demo2.md)
(For OS, R version, and OpenMx version, see the demo)

**Example data:** <br>
- [Data](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/example_data.csv)

**Source Code:** <br>
***R package: OpenMx*** <br>
- [Full Mixture Model (Full mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/OpenMx_E2/full_MoE.R)
- [Growth Predictor Mixture Model (Expert-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/OpenMx_E2/expert_MoE.R)
- [Cluster Predictor Mixture Model (Gating-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/OpenMx_E2/gating_MoE.R)
- [Finite Mixture Model](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/OpenMx_E2/FMM.R)

***MPlus 8*** <br>
- [Full Mixture Model (Full mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/Full%20MoE.inp)
- [Growth Predictor Mixture Model (Expert-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/Expert-network%20MoE.inp)
- [Cluster Predictor Mixture Model (Gating-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/Gating-network%20MoE.inp)
- [Finite Mixture Model](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/MPlus8_E2/FMM.inp)

**In this part, we further extend the full mixture model to allow time-varying covariates and provide *OpenMx* code.**
- [Full mixture model with time-varying covariates](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_extension/OpenMx_E2R/fun_for_VaryingMoE.R)

**This project also provides *OpenMx* code with common parametric functional forms to capture nonlinear change patterns.**
- [Quadratic growth curve](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_sensitivity/full_MoE_quad.R)
- [Jenss-Bayley growth curve](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_sensitivity/full_MoE_JB.R)

## Part III: Growth Mixture Model to Investigate Heterogeneity in Nonlinear Joint Development with Individual Measurement Occasions
**Manuscript Title:** <br>
Extending Growth Mixture Model to Assess Heterogeneity in Joint Development with Piecewise Linear Trajectories in the Framework of Individual Measurement Occasions

**Description:** <br>
In this part, we extended Growth Mixture Models to investigate heterogeneity in nonlinear joint development with individual measurement occasions:
- GMM with a PBLSGM (fixed knots) as the within-class model

**Demo:** 
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%203/OpenMx_demo3.md)
(For OS, R version, and OpenMx version, see the demo)

**Source Code:** <br>
Will upload later.

## Part IV: Jenss-Bayley Latent Change Score Model with Individual Ratio of Growth Acceleration in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Jenss-Bayley Latent Change Score Model with Individual Ratio of Growth Acceleration in the Framework of Individual
Measurement Occasions

**Description:** <br>
In this part, we extend an existing LCSM with the Jenss-Bayley growth curve and propose a novel expression of change scores that allows for (1) unequally-spaced study waves and (2) individual measurement occasions around each wave. We also extend the existing model to estimate the individual ratio of growth acceleration (that largely determines the trajectory shape and is viewed as the most important parameter in the Jenss-Bayley model). 
- Jenss-Bayley Latent Change Score Model with Random Ratio of Growth Acceleration
- Jenss-Bayley Latent Change Score Model with Fixed Ratio of Growth Acceleration

**Demo:** 
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%204/OpenMx_demo4.md)
(For OS, R version, and OpenMx version, see the demo)

**Source Code:** <br>
Will upload later.

## Part V: Parallel Latent Basis Growth Model in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Extending Latent Basis Growth Model to Explore Joint Development in the Framework of Individual Measurement Occasions

**Description:** <br>
In this part, we propose a novel specification for LBGMs that allows for (1) unequally-spaced study waves and (2) individual measurement occasions around each wave. We then extend LBGMs to explore multiple repeated outcomes because longitudinal processes rarely unfold in isolation. 
- Parallel Latent Basis Growth Model

**Demo:** 
- [*R* package: *OpenMx*](https://github.com/Veronica0206/Extension_projects/blob/master/Part%205/OpenMx_demo5.md)
(For OS, R version, and OpenMx version, see the demo)

**Source Code:** <br>
Will upload later.

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
