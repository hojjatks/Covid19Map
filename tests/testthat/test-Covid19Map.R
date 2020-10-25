test_that("multiplication works", {

  Data1<-Covid19Map:: GetFullTimeseries()

  expect_equal(is.data.frame(Data1), TRUE)
})
