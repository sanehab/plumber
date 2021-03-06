context("Content Types")

test_that("contentType serializes properly", {
  l <- list(a=1, b=2, c="hi")
  val <- serializer_content_type("somethinghere")(l, list(), PlumberResponse$new(), stop)
  expect_equal(val$status, 200L)
  expect_equal(val$headers$`Content-Type`, "somethinghere")
  expect_equal(val$body, l)
})

test_that("empty contentType errors", {
  expect_error(serializer_content_type())
})

test_that("contentType works in files", {

  r <- pr(test_path("files/content-type.R"))
  val <- r$call(make_req("GET", "/"))
  expect_equal(val$headers$`Content-Type`, "text/plain")
})

test_that("Parses charset properly", {
  charset <- get_character_set("Content-Type: text/html; charset=latin1")
  expect_equal(charset, "latin1")
  charset <- get_character_set("Content-Type: text/html; charset=greek8")
  expect_equal(charset, "greek8")
})

test_that("Defaults charset when not there", {
  charset <- get_character_set("Content-Type: text/html")
  expect_equal(charset, "UTF-8")
  charset <- get_character_set(NULL)
  expect_equal(charset, "UTF-8")
})


test_that("File extensions can be found from the content type", {
  expect_equal(get_fileext("application/json"), "json")
  expect_equal(get_fileext("not a match"), NULL)
})
