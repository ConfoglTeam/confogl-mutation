// Set up test environment
dofile("tests/fake_env.nut",true);


::Test <- {};

local tests = split(getenv("NUT_TESTS"), "\n")

foreach (file in tests) {
  IncludeScript(file, ::Test);
}
