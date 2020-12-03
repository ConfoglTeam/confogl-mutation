// Set up test environment
dofile("tests/fake_env.nut",true);


::Test <- {};
::EventScopes <- [];

local tests = split(getenv("NUT_TESTS"), "\n")

local failure = false;
function expect(condition, message) {
  if(!condition) {
    error(format("EXPECT FAILURE: %s\n", message));
    failure = true;
  }
}

foreach (file in tests) {
  ::Test = {}
  IncludeScript(file, ::Test);
}

if (failure) {
  return 1;
}