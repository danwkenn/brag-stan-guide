// Comments in STAN are defined with //
// Every quantity is "declared", and bounds given if appropriate.

// Data block which defines the input data:
data {
  int<lower=0> n_trials; // number of coin-flip trials
  int<lower=0,upper=1> Y[n_trials]; // data (heads = 1, tails = 0)
}

// Parameter block which defines the parameters of interest for
// posterior inference.
parameters {
  real phi; // logit-probability as parameter of interest
}

// Transformed parameter block defines values which are some
// function of the parameters.
transformed parameters {
  real<lower=0,upper=1> theta;
  theta = exp(phi)/(1+exp(phi)); // probability as a function of phi.
}

// Model block is where the prior and generative process of the data are defined from
// the parameters and transformed parameters.
model {
  phi ~ normal(0,10^4); // prior for phi is a wide (SD = 10^4) normal distribution centered at 0.

  Y ~ bernoulli(theta); // define the likelihood with vector statement.
  
  // You can also define using a for loop, looping over each trial:
  // for(trial in 1:n_trials){
  //   Y[trial] ~ bernoulli(theta); // define 
  // }
}

// Generated quantities block is for values that are functions of the data and/or parameters.
// Examples are predicted values and tansformations of the parameters not used in the model{} block.
generated quantities {
  int<lower=0,upper=1> Y_dash; // Prediction for new trial
  real<lower=0> relative_odds; // Relative odds (how likely is heads compared to tails?)
  relative_odds = theta/(1-theta);
  Y_dash = bernoulli_rng(theta);
}
