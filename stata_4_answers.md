## PART 1
- P1.3 the number of individuals required to reach 80% power when trying to detect 0.1 sd treatment effect is 3,000 <br />
- P1.4 with 15% attrition, the required sample size for 80% power increases to 3,500 <br />
- P.5 if only able to afford to provide treatment to 30% of the sample, the sample size needed for 80% power increases further to 4,100 <br />

## PART 2
- P.5 I would recommend a cluster size of 8 (ie 2^3) because it achieves high power (92.8%) and power only increases slightly when going to larger cluster size like 2^4 (16), which only provides a relatively small increase (from 92.8% to 97.2%). Using a smaller cluster size is more economical in terms of time and resources which are important considerations in planning a study.  <br />
- P.6 To achieve 80% power, at least 90 schools (with 15 students each) would be required to detect a 0.2 sd treatment effect in the study. <br />
- P.7 230 schools would be needed to achieve 80% power with only 70% takeup of treatment. 230 schools would give a power of 0.824 

## PART 3
I created 3 different covariates: 
  - covariate1: which affects both treatment assignment and outcome (a confounder)
  - covariate2: which affects outcome but not treatment
  - covariate3: which affects treatment but not outcome
- Treatment assignment depends on `covariate1` and `covariate3`, and i run simulations with four different sample sizes of N = 27, 243, 2187 and 19683 

- we see:
- **convergence** in the results since the distributions of coefficient estimates become narrower as sample size increases.
- **reduction of bias** since the coefficient distributions for different models are centered differently which suggests that some models reduce bias more effectively than others.
- **effects of increasing sample size**: The graphs  show that at smaller sample sizes (N=27, N=243), the estimates have higher variance, whereas, at larger sample sizes (N=2,187, N=19,683), the distributions become more concentrated.
