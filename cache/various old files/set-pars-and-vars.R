# set-pars-and-vars.R
rm(list = ls(all.names = TRUE))

#this is a simple script that specifies model parameters, and variable names
#it then assigns values for initial conditions and parameters
#the idea is that there is a single place to specify them and will be loaded by other scripts

library(here)

# State variables to track ------------------------------------------------
varnames <- c("S", 
              "E1", "E2", "E3", "E4",  
              "Ia1", "Ia2", "Ia3", "Ia4", 
              "Isu1", "Isu2", "Isu3", "Isu4", 
              "Isd1", "Isd2", "Isd3", "Isd4", 
              "C1", "C2", "C3", "C4",  
              "H1", "H2", "H3", "H4",
              "C_new", "H_new", "D_new",
              "R",
              "D")

#initial conditions are also considered parameters and some are estimated
#we supply them on a log scale and in the code exponentiate to ensure no negative values
inivals <- c(S_0 = 10600000, 
             E1_0 = log(40), #E2_0 = 40, E3_0 = 40, E4_0 = 40, 
             Ia1_0 = log(22), #Ia2_0 = 22, Ia3_0 = 22, Ia4_0 = 22, 
             Isu1_0 = log(90),# Isu2_0 = 90, Isu3_0 = 90, Isu4_0 = 90, 
             Isd1_0 = log(14), #Isd2_0 = 14, Isd3_0 = 14, Isd4_0 = 14, 
             C1_0 = 2, #C2_0 = 2, C3_0 = 2, C4_0 = 2, 
             H1_0 = 2, #H2_0 = 2, H3_0 = 2, H4_0 = 2, 
             R_0 = 0,
             D_0 = 0
)

Ntot <- sum(inivals)  # total population size - needed below

inipars <- names(inivals)

# Parameters --------------------------------------------------------------

#note that a lot of parameters below are transformed versions of what the meaning specifies
#see the Google sheet for detailed definitions and explanations
parvals <- c(log_beta_s = log(0.4/Ntot), #rate of infection of symptomatic 
             trans_e = 2, trans_a = 0, trans_c = 1,  trans_h = 10,  #parameter that determines relative infectiousness of E/Ia/C classes compared to Isu/Isd 
             log_g_e = log(4/4), #rate of movement through E/Ia/Isu/Isd/C/H compartments
             log_g_a = log(4/3.5),
             log_g_su = log(4/6),
             log_g_sd = log(4/3),
             log_g_c = log(4/3),  
             log_g_h = log(4/12),
             #log_max_diag = 0, #max for factor by which movement through Isd happens faster (quicker diagnosis) 
             #log_diag_inc_rate = -3, #rate at which faster diagnosis ramps up to max
             #max_detect_par = 0,  #max fraction detected
             #log_detect_inc_rate = -3, #speed at which fraction detected ramps up
             log_diag_speedup = log(1),
             detect_0 = log(2),
             detect_1 = log(0.5),
             frac_asym = 1.5, #fraction asymptomatic
             frac_hosp = 3, #fraction diagnosed that go into hospital
             frac_dead = 1.2, #fraction hospitalized that die
             log_theta_cases = log(10),
             log_theta_hosps = log(10),
             log_theta_deaths = log(10),
             log_sigma_dw = log(0.1),
             t_int = 12
)

parnames <- names(parvals)

#all parameter values, including initial conditions
allparvals = c(parvals,inivals)
#all names

# we currently estimate all parameters
params_to_estimate <- parnames[-which(names(parnames) == "t_int")]

# Specify which initial conditions to estimate
inivals_to_estimate <- c(                        
  "E1_0", 
  "Ia1_0", 
  "Isu1_0",  
  "Isd1_0"
)

# inivals_to_estimate <- c(                        
#   "E1_0", "E2_0", "E3_0", "E4_0",  
#   "Ia1_0", "Ia2_0", "Ia3_0", "Ia4_0", 
#   "Isu1_0", "Isu2_0", "Isu3_0", "Isu4_0", 
#   "Isd1_0", "Isd2_0", "Isd3_0", "Isd4_0" 
# )

par_var_list = list()
par_var_list$params_to_estimate =  params_to_estimate
par_var_list$inivals_to_estimate = inivals_to_estimate
par_var_list$varnames = varnames
par_var_list$parnames = parnames
par_var_list$allparvals = allparvals

filename = here('output/var-par-definitions.RDS')
saveRDS(par_var_list,filename)

