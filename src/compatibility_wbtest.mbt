///|
test "production client defaults preserve configuration" {
  let (config, http) = new_client("test-key")
  assert_eq(config.0, "test-key")
  assert_eq(config.1, "https://api.openai.com/v1")
  assert_eq(config.2, 20)
  assert_eq(config.3, 2)
  assert_eq(http.0, config.1)
  assert_eq(http.1, config.2)
  assert_eq(http.2, config.3)
}

///|
test "production request headers normalize case and preserve values" {
  let headers = headers_array_to_map([
    "Authorization: Bearer test", "Accept: old", "accept: new",
  ])
  assert_eq(headers.length(), 2)
  assert_eq(
    headers.get(@http.CaseInsensitiveString("AUTHORIZATION")),
    Some("Bearer test"),
  )
  assert_eq(headers.get(@http.CaseInsensitiveString("Accept")), Some("new"))
}

///|
test "production response header conversion retains colon values" {
  let headers = Map([
    (@http.CaseInsensitiveString("Location"), "https://example.com/path"),
  ])
  let converted = response_headers_to_array(headers)
  assert_eq(converted.length(), 1)
  assert_eq(converted[0], "location: https://example.com/path")
}
