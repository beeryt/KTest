// KTest is a unit test framework inspired by gtest.
// It can be used to write unit tests in kerboscript
//
// This is an example program which uses KTest to
// create several tests within two test cases.
//
// Execution of this program expects lib_ktest to be
// in the same directory, but the path may be specified
// using the path_to_ktest parameter.

@LAZYGLOBAL OFF.
PARAMETER path_to_ktest IS "lib_ktest".
RUNPATH(path_to_ktest).

TEST("MyTestSuite", "MyTestA", {
  ASSERT_TRUE(TRUE).
}).

TEST("MyTestSuite", "MyTestB", {
  ASSERT_FALSE(FALSE).
}).

TEST("FaultySuite", "Fault", {
  ASSERT_TRUE(FALSE).
}).

RUN_ALL_TESTS().
