library(testthat)
library(agua)

# Working on figuring out an issue where the first test runs but others fail with
# Unexpected CURL error: Failed to connect to localhost port 54321 after 1 ms: Connection refused
# [1] "Job request failed Unexpected CURL error: Failed to connect to localhost port 54321 after 1 ms: Connection refused, will retry after 3s."
agua::h2o_start()
test_check("agua")
h2o::h2o.shutdown(prompt = FALSE)
