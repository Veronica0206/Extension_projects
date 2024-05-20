# Extension projects

## Part I: Parallel Bilinear Spline Growth Models (PBLSGMs) in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Estimating Knots and Their Association in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions (***Psychological Methods*, 2021, [Advance online publication](https://doi.org/10.1037/met0000309)**)

**Description:** <br>
In this part, we developed two models in unstructured time framework:
- PBLSGMs for estimating fixed knots 
- PBLSGMs for estimating random knots

**Example data:** <br>
- [Data](https://github.com/Veronica0206/Extension_projects/tree/master/Part1/Data/Bi_BLS_dat.RData)

**Source Code:** <br>
***R package: nlpsem*** <br>
**The models developed in this project are now part of *R* package *nlpsem* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [*R* package: *nlpsem*](https://github.com/Veronica0206/Extension_projects/blob/master/Part1/OpenMx/OpenMx_demo.md)

***MPlus 8*** <br>
- [PBLSGMs for estimating fixed knots](https://github.com/Veronica0206/Extension_projects/tree/master/Part1/MPlus8/PBLSGM_Unknown%20Fixed%20Knot.inp)
- [PBLSGMs for estimating random knots](https://github.com/Veronica0206/Extension_projects/tree/master/Part1/MPlus8/PBLSGM_Unknown%20Random%20Knot.inp)

## Part II: Extending Mixture of Experts Model to Investigate Heterogeneity of Trajectories
**Manuscript Title:** <br>
Extending Mixture of Experts Model to Investigate Heterogeneity of Trajectories: When, Where and How to Add Which Covariates (***Psychological Methods*, 2022, [Advance online publication](https://doi.org/10.1037/met0000436)**)

**Description:** <br>
In this part, we extended Mixture-of-Experts Models to the SEM framework with individual measurement occasions:
- Full Mixture Model (Full mixture of experts)
- Growth Predictor Mixture Model (Expert-network mixture of experts)
- Cluster Predictor Mixture Model (Gating-network mixture of experts)
- Finite Mixture Model

**Example data:** <br>
- [Data](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Main/Data/BLS_dat2.RData)

**Source Code:** <br>
***R package: nlpsem*** <br>
**The models developed in this project are now part of *R* package *nlpsem* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [*R* package: *nlpsem*](https://github.com/Veronica0206/Extension_projects/blob/master/Part2/Main/OpenMx/OpenMx_demo.md)

***MPlus 8*** <br>
- [Full Mixture Model (Full mixture of experts)](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Main/MPlus8/Full%20MoE.inp)
- [Growth Predictor Mixture Model (Expert-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Main/MPlus8/Expert-network%20MoE.inp)
- [Cluster Predictor Mixture Model (Gating-network mixture of experts)](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Main/MPlus8/Gating-network%20MoE.inp)
- [Finite Mixture Model](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Main/MPlus8/FMM.inp)

**In this part, we further extend the full mixture model to allow time-varying covariates and provide *OpenMx* code.**
- [Full mixture model with time-varying covariates](https://github.com/Veronica0206/Extension_projects/blob/master/Part%202/R1_extension/fun_for_VaryingMoE.R)

**This project also provides *OpenMx* code with common parametric functional forms to capture nonlinear change patterns.**
- Quadratic growth curve
- Exponential growth curve
- Jenss-Bayley growth curve

**Example data:** <br>
- [Quadratic growth curve](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Sensitivity/Data/QUAD_dat2.RData)
- [Exponential growth curve](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Sensitivity/Data/EXP_dat2.RData)
- [Jenss-Bayley growth curve](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Sensitivity/Data/JB_dat2.RData)

**Source Code:** <br>
- [*R* package: *nlpsem*](https://github.com/Veronica0206/Extension_projects/tree/master/Part2/Sensitivity/OpenMx/OpenMx_demo.md)

## Part III: Growth Mixture Model to Investigate Heterogeneity in Nonlinear Joint Development with Individual Measurement Occasions
**Manuscript Title:** <br>
Extending Growth Mixture Model to Assess Heterogeneity in Joint Development with Piecewise Linear Trajectories in the Framework of Individual Measurement Occasions (***Psychological Methods*, 2022, [Advance online publication](https://doi.org/10.1037/met0000500)**)

**Description:** <br>
In this part, we extended Growth Mixture Models to investigate heterogeneity in nonlinear joint development with individual measurement occasions:
- PBLSGMM with fixed knots w/o cluster predictor
- PBLSGMM with fixed knots w/ cluster predictor

**Example data:** <br>
- [Data](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Main/Data/Bi_BLS_dat2.RData)

**Source Code:** <br>
***R package: nlpsem*** <br>
**The models developed in this project are now part of *R* package *nlpsem* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [*R* package: *nlpsem*](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Main/OpenMx/OpenMx_demo.md)
  
***MPlus 8*** <br>
- [PBLSGMM with fixed knots w/ cluster predictor](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Main/MPlus8/PBLSGMM.inp)

**This project also provides *OpenMx* code with common parametric functional forms to capture nonlinear change patterns.**
- Quadratic growth curve
- Exponential growth curve
- Jenss-Bayley growth curve

**Example data:** <br>
- [Quadratic growth curve](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Sensitivity/Data/Bi_QUAD_dat2.RData)
- [Exponential growth curve](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Sensitivity/Data/Bi_EXP_dat2.RData)
- [Jenss-Bayley growth curve](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Sensitivity/Data/Bi_JB_dat2.RData)

**Source Code:** <br>
- [*R* package: *nlpsem*](https://github.com/Veronica0206/Extension_projects/tree/master/Part3/Sensitivity/OpenMx/OpenMx_demo.md)

## Part VI: Mediational Processes in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions
**Manuscript Title:** <br>
Assessing Mediational Processes in Parallel Bilinear Spline Growth Curve Models in the Framework of Individual Measurement Occasions. (Accepted for publication in ***Behavior Research Methods***)

**Description:** <br>
In this study, we extend latent growth mediation models with linear trajectories (Cheong et al., 2003) and develop two models to evaluate mediational processes where the bilinear spline (i.e., the linear-linear piecewise) growth model is utilized to capture the change patterns. We define the mediational process as either the baseline covariate or the change of covariate influencing the change of the mediator, which, in turn, affects the change of the outcome. 
- Baseline predictor->longitudinal mediator->longitudinal outcome
- Longitudinal predictor->longitudinal mediator->longitudinal outcome

**Example data:** <br>
- [Baseline predictor](https://github.com/Veronica0206/Extension_projects/tree/master/Part4/Data/MED2_BLS_dat.RData)
- [Longitudinal predictor](https://github.com/Veronica0206/Extension_projects/tree/master/Part4/Data/MED3_BLS_dat.RData)

**Source Code:** <br>
***R package: nlpsem*** <br>
**The models developed in this project are now part of *R* package *nlpsem* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**
- [*R* package: *nlpsem*](https://github.com/Veronica0206/Extension_projects/tree/master/Part4/OpenMx/OpenMx_demo.md)

## Special instructions of repositories “Dissertation_projects” and “Extension_projects”:

**We developed multiple models in the six projects described in these two repositories. *R* functions for all developed models are now part of *R* package *[NonLinearCurve](https://github.com/Veronica0206/NonLinearCurve/blob/main/R/)* (dependency: *OpenMx*), where we provide functions capable of 'calculating' starting values from the input and generate the estimates described in the manuscript.**<br>

**We provide a flow chart below to recommend ```when``` to use ```which model``` in this collection.**<br>

![](https://github.com/Veronica0206/Extension_projects/blob/master/plot.jpg)<!-- -->

**Suppose we have longitudinal records of reading ability and mathematics ability, and we view the development of two abilities as two stages (see the pink line and purple diamond in the plot below). From each of proposed models, we are able to have the following ```insights```.**<br>

![](https://github.com/Veronica0206/Extension_projects/blob/master/Demo.jpg)<!-- -->

**Project 1 (univariate longitudinal outcome, one population assumption):**<br>
- BLSGMs for estimating fixed knots (```BLSGM_fixed.R```): 
  - estimating **individual growth rate** in reading (mathematics) ability during each phase, 
  - identifying **transition time from one stage to another** with the **assumption** that *the transition time is roughly the same across the population*. 

- BLSGMs for estimating random knots (```BLSGM_random.R```): 
  - estimating **individual growth rate** in reading (mathematics) ability during each phase, 
  - identifying **individual transition time from one stage to another**. 

- BLSGMs-TICs for estimating fixed knots (```BLSGM_TIC_fixed.R```): 
  - estimating **individual growth rate** in reading (mathematics) ability during each phase,
  - identifying **transition time from one stage to another** with the **assumption** that *the transition time is roughly the same across the population*, 
  - examining **the effects of a wide range of individual characteristics**, such as *approach to learning* and *attentional focus*, on their differences in reading (mathematics) development.

- BLSGMs-TICs for estimating random knots (```BLSGM_TIC_random.R```): 
  - estimating **individual growth rate** in reading (mathematics) ability during each phase, 
  - identifying **individual transition time from one stage to another**, 
  - examining **the effects of a wide range of individual characteristics**, such as *approach to learning* and *attentional focus*, on their differences in reading (mathematics) development. 

**Project 2 (univariate longitudinal outcome, explore possible sub-populations):**<br>
- Two-step BLSGMMs for estimating fixed knots (```BLSGMM_2steps.R```):
  - First step: soft cluster development trajectories of reading (mathematics) ability. For each cluster, the model provides the same insights as such from ```BLSGM_fixed.R```.
  - Second step: regress **the vector of posterior probabilities** on baseline covariates and investigate predictors for clusters.

**Project 3 (multivariate longitudinal outcome, one population assumption):**<br>
- PBLSGMs for estimating fixed knots (```PBLSGM_fixed.R```): 
  - the insights we obtained from ```BLSGM_fixed.R``` if we use the function to analyze reading and mathematics development, 
  - allows for estimating **intercept-intercept correlation** and **pre- and post-knot slope-slope correlation** between the development of reading ability and mathematics ability.

- PBLSGMs for estimating random knots (```PBLSGM_random.R```): 
  - the insights we obtained from ```BLSGM_random.R``` if we use the function to analyze reading and mathematics development, 
  - allows for estimating **intercept-intercept correlation**, **pre- and post-knot slope-slope correlation**, and **knot-knot correlation** between the development of reading ability and mathematics ability.

**Project 4 (univariate longitudinal outcome, explore possible sub-populations):**<br>
- Full Mixture Model (Full mixture of experts, ```BLSGM_fullMM.R```): 
  - the insights that obtained from the first step of ```BLSGMM_2steps.R```, 
  - allows for covariates to **inform the cluster formation** and **explain the with-cluster variability** in trajectories. 

- Growth Predictor Mixture Model (Expert-network mixture of experts, ```BLSGM_GPMM.R```): 
  - the insights that obtained from the first step of ```BLSGMM_2steps.R```, 
  - allows for covariates to **explain the with-cluster variability in trajectories**. 

- Cluster Predictor Mixture Model (Gating-network mixture of experts, ```BLSGM_CPMM.R```): 
  - the insights that obtained from the first step of ```BLSGMM_2steps.R```, 
  - allows for covariates to **inform the cluster formation**. 

- Finite Mixture Model (```BLSGM_FMM.R```): the same insights as such obtained the first step of ```BLSGMM_2steps.R```.

**Project 5 (multivariate longitudinal outcome, explore possible sub-populations):**<br>
- PBLSGMM with fixed knots w/ cluster predictor (```BLSGM_CPMM.R```): 
  - soft cluster development trajectories of reading (mathematics) ability. 
  - for each cluster, the model provides the same insights as such from ```PBLSGM_fixed.R```. 
  - the proposed model allows for covariates to **inform the cluster formation**. 

**Note that we also explore the heterogeneity in the correlation between reading and mathematics development with the proposed model**. 

**Project 6 (mediation effects among multivariate longitudinal outcome, one population assumption):**<br>
will add later.

In addition, 
- Project 4 documents how to use latent Kappa statistics (Dumenci, 2011) to quantify the agreement between latent groups obtained from two clustering algorithms and the corresponding simulation studies.
- Project 5 documents how to use growth mixture models (Muthén & Shedden, 1999), exploratory factor analysis (EFA) (Spearman, 1904) and SEM forests (Brandmaier et al., 2016) to perform holistic assessments when exploring possible sub-groups of (joint) development and provide recommendations for real-world analyses.
