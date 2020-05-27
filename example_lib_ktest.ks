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

TEST("AssertionChecks", "GoodAssertions", {
  ASSERT_TRUE(TRUE).
  ASSERT_FALSE(FALSE).
  ASSERT_EQ(1,1).
  ASSERT_NE(0,1).
  ASSERT_LT(0,1).
  ASSERT_LE(0,1).
  ASSERT_GT(1,0).
  ASSERT_GE(1,0).
}).

TEST("AssertionChecks", "BadAssertions", {
  ASSERT_TRUE(FALSE).
  ASSERT_FALSE(TRUE).
  ASSERT_EQ(0,1).
  ASSERT_NE(1,1).
  ASSERT_LT(1,0).
  ASSERT_LE(1,0).
  ASSERT_GT(0,1).
  ASSERT_GE(0,1).
}).

TEST("ExampleTestSuite", "TestCase1", {
  ASSERT_TRUE(TRUE).
}).

TEST("ExampleTestSuite", "TestCase2", {
  ASSERT_TRUE(TRUE).
}).

RUN_ALL_TESTS().
