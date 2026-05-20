generate_Y <- function() {

  Z <- sample(1:4, size = 1)

  if (Z == 1) {

    return(sample(c(-1, 1), size = 1))

  } else if (Z == 2) {

    return(runif(1,
                 -sqrt(3),
                 sqrt(3)))

  } else if (Z == 3) {

    return(rnorm(1))

  } else {

    return(rexp(1) - 1)
  }
}

generate_increments <- function(n) {

  replicate(n, generate_Y())
}
