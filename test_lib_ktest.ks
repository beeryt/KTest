@LAZYGLOBAL OFF.
PARAMETER path_to_ktest IS "lib_ktest".
RUNPATH(path_to_ktest).

TEST("Predicates", "TRUE", {
  // can't use ASSERT_TRUE because it depends on PRED_TRUE
  IF NOT PRED_TRUE(TRUE) ASSERT_FAIL("PRED_TRUE(TRUE) returned FALSE!").
  IF PRED_TRUE(FALSE) ASSERT_FAIL("PRED_TRUE(FALSE) returned TRUE!").
}).

TEST("Predicates", "FALSE", {
  // can't use ASSERT_FALSE because it depends on PRED_FALSE
  IF NOT PRED_FALSE(FALSE) ASSERT_FAIL("PRED_FALSE(FALSE) returned FALSE!").
  IF PRED_FALSE(TRUE) ASSERT_FAIL("PRED_FALSE(TRUE) returned TRUE!").
}).

TEST("Predicates", "EQ", {
  ASSERT_TRUE(PRED_EQ(1,1)).
  ASSERT_FALSE(PRED_EQ(1,2)).
}).

TEST("Predicates", "NE", {
  ASSERT_TRUE(PRED_NE(1,2)).
  ASSERT_FALSE(PRED_NE(1,1)).
}).

TEST("Predicates", "LT", {
  ASSERT_TRUE(PRED_LT(1,2)).
  ASSERT_FALSE(PRED_LT(2,2)).
  ASSERT_FALSE(PRED_LT(3,2)).
}).

TEST("Predicates", "GE", {
  ASSERT_FALSE(PRED_GE(1,2)).
  ASSERT_TRUE(PRED_GE(2,2)).
  ASSERT_TRUE(PRED_GE(3,2)).
}).

TEST("Predicates", "GT", {
  ASSERT_TRUE(PRED_GT(3,2)).
  ASSERT_FALSE(PRED_GT(2,2)).
  ASSERT_FALSE(PRED_GT(1,2)).
}).

TEST("Predicates", "LE", {
  ASSERT_FALSE(PRED_LE(3,2)).
  ASSERT_TRUE(PRED_LE(2,2)).
  ASSERT_TRUE(PRED_LE(1,2)).
}).

RUN_ALL_TESTS().
