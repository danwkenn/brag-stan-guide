data {
  int<lower=0> N;
  int<lower=2> N_new;
  vector[N] y;
}
parameters {
  real gamma;
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  for (n in 2:N){
    y[n] ~ normal(alpha + beta * y[n-1] + gamma * n, sigma);
    }
}

generated quantities{
  real y_new[N_new];
  y_new[1] = normal_rng(alpha + beta * y[N] + gamma * (N + 1), sigma);
  for (n in 2:N_new){
    y_new[n] = normal_rng(alpha + beta * y_new[n-1] + gamma * (n + N), sigma);
  }
}