@LAZYGLOBAL OFF.


///*
// *  TEST is used to register a testBody to a given testName within a testCase.
// *
// *  @param testCase A string identifier for what test case this test is part of.
// *  @param testName A string identifier for the name of this specific test.
// *  @param testBody A function delegate for the test to register.
// */
FUNCTION TEST {
  PARAMETER testCase.
  PARAMETER testName.
  PARAMETER testBody.

  // create testCase if it doesn't exist
  IF NOT _test_cases:HASKEY(testCase) {
    _test_cases:ADD(testCase, LEXICON()).
  }

  // check if testName already exists
  IF _test_cases[testCase]:HASKEY(testName) {
    PRINT "TEST FRAMEWORK ERROR: " + testCase + " already has test named " + testName.
    RETURN 1 / 0.
  }

  // add testBody to internal tracker
  _test_cases[testCase]:ADD(testName, testBody).
}


///*
// *  RUN_ALL_TESTS is used to run all tests registered using the TEST "macro".
// */
FUNCTION RUN_ALL_TESTS {
  LOCAL test_case_count IS _test_cases:LENGTH.
  LOCAL total_test_count IS 0.
  LOCAL failed_test_list IS LIST().

  // get total test count
  FOR test_case IN _test_cases:KEYS {
    SET total_test_count TO total_test_count + _test_cases[test_case]:LENGTH.
  }

  LOCAL display_total_count IS DisplayCount(total_test_count, "test").
  LOCAL display_case_count IS DisplayCount(test_case_count, "test case").
  PRINT "[==========] Running " + display_total_count + " from " + display_case_count + ".".
  PRINT "[----------] Global test environment set-up.".

  // process each test case
  FOR test_case IN _test_cases:KEYS {
    LOCAL display_test_count IS DisplayCount(_test_cases[test_case]:LENGTH, "test").
    PRINT "[----------] " + display_test_count + " from " + test_case + ".".

    // process each test in test_case
    FOR test_name IN _test_cases[test_case]:KEYS {
      PRINT "[ RUN      ] " + test_case + "." + test_name.
      SET _test_success TO TRUE. // assume test success
      _test_cases[test_case][test_name]:CALL().
      IF _test_success {
        PRINT "[       OK ] " + test_case + "." + test_name.
      } ELSE {
        PRINT "[  FAILED  ] " + test_case + "." + test_name.
        failed_test_list:ADD(test_case + "." + test_name).
      }
    }

    PRINT "[----------] " + display_test_count + " from " + test_case + ".".
    PRINT " ".
  }

  LOCAL display_tests_passed IS DisplayCount(total_test_count - failed_test_list:LENGTH, "test").
  LOCAL display_tests_failed IS DisplayCount(failed_test_list:LENGTH, "test").

  PRINT "[----------] Global test environment tear-down.".
  PRINT "[==========] " + display_total_count + " from " + display_case_count + " ran.".
  PRINT "[  PASSED  ] " + display_tests_passed + ".".
  IF failed_test_list:LENGTH > 0 {
    PRINT "[  FAILED  ] " + display_tests_failed + ", listed below:".
    FOR test_id IN failed_test_list {
      PRINT "[  FAILED  ] " + test_id.
    }
  }
  PRINT " ".
  PRINT DisplayCount(failed_test_list:LENGTH, "FAILED TEST").
}


// assertion
GLOBAL ASSERT_EQ    IS ASSERT_PRED2@:BIND(FATAL@, PRED_EQ@).
GLOBAL ASSERT_NE    IS ASSERT_PRED2@:BIND(FATAL@, PRED_NE@).
GLOBAL ASSERT_LT    IS ASSERT_PRED2@:BIND(FATAL@, PRED_LT@).
GLOBAL ASSERT_LE    IS ASSERT_PRED2@:BIND(FATAL@, PRED_LE@).
GLOBAL ASSERT_GT    IS ASSERT_PRED2@:BIND(FATAL@, PRED_GT@).
GLOBAL ASSERT_GE    IS ASSERT_PRED2@:BIND(FATAL@, PRED_GE@).
GLOBAL ASSERT_TRUE  IS ASSERT_PRED1@:BIND(FATAL@, PRED_TRUE@).
GLOBAL ASSERT_FALSE IS ASSERT_PRED1@:BIND(FATAL@, PRED_FALSE@).

GLOBAL EXPECT_EQ    IS ASSERT_PRED2@:BIND(NONFATAL@, PRED_EQ@).
GLOBAL EXPECT_NE    IS ASSERT_PRED2@:BIND(NONFATAL@, PRED_NE@).
GLOBAL EXPECT_LT    IS ASSERT_PRED2@:BIND(NONFATAL@, PRED_LT@).
GLOBAL EXPECT_LE    IS ASSERT_PRED2@:BIND(NONFATAL@, PRED_LE@).
GLOBAL EXPECT_GT    IS ASSERT_PRED2@:BIND(NONFATAL@, PRED_GT@).
GLOBAL EXPECT_GE    IS ASSERT_PRED2@:BIND(NONFATAL@, PRED_GE@).
GLOBAL EXPECT_TRUE  IS ASSERT_PRED1@:BIND(NONFATAL@, PRED_TRUE@).
GLOBAL EXPECT_FALS  IS ASSERT_PRED1@:BIND(NONFATAL@, PRED_FALSE@).


// common predicates used for assertions
LOCAL FUNCTION PRED_EQ { PARAMETER a, b. RETURN a = b. }
LOCAL FUNCTION PRED_NE { PARAMETER a, b. RETURN a <> b. }
LOCAL FUNCTION PRED_LT { PARAMETER a, b. RETURN a < b. }
LOCAL FUNCTION PRED_LE { PARAMETER a, b. RETURN a <= b. }
LOCAL FUNCTION PRED_GT { PARAMETER a, b. RETURN a > b. }
LOCAL FUNCTION PRED_GE { PARAMETER a, b. RETURN a >= b. }
LOCAL FUNCTION PRED_TRUE { PARAMETER a. RETURN a. }
LOCAL FUNCTION PRED_FALSE { PARAMETER a. RETURN NOT a. }


///*
// *  ASSERT_ is used by all asserts in this library.
// *
// *  @param failureCallback  A delegate which is called when assertion fails.
// *  @param expression       evaluates TRUE if assertion success, otherwise FALSE.
// *  @param message          A custom failure message to display if assertion fails.
// */
LOCAL FUNCTION ASSERT_ {
  PARAMETER failureCallback.
  PARAMETER expression.
  PARAMETER message IS "".

  IF NOT expression {
    failureCallback(expression).
  }
}


///*
// *  ASSERT_PRED1 binds a predicate function to 1 parameter.
// *
// *  @param failureCallback  A delegate which is called when assertion fails.
// *  @param predicate        A delegate which determines assertion success/failure.
// *  @param param1           First parameter provided to predicate.
// *  @param message          A custom failure message to display if assertion fails.
// */
  LOCAL FUNCTION ASSERT_PRED1 {
  PARAMETER failureCallback.
  PARAMETER predicate.
  PARAMETER param1.
  PARAMETER message IS "".

  ASSERT_(failureCallback, predicate(param1)).
}


///*
// *  ASSERT_PRED2 binds a predicate function to 2 parameters.
// *
// *  @param failureCallback  A delegate which is called when assertion fails.
// *  @param predicate        A delegate which determines assertion success/failure.
// *  @param param1           First parameter provided to predicate.
// *  @param param2           Second parameter provided to predicate.
// *  @param message          A custom failure message to display if assertion fails.
// */
LOCAL FUNCTION ASSERT_PRED2 {
  PARAMETER failureCallback.
  PARAMETER predicate.
  PARAMETER param1, param2.
  PARAMETER message IS "".

  ASSERT_(failureCallback, predicate(param1, param2)).
}


// implementation for failureCallback used in fatal assertions (ASSERT_*).
LOCAL FUNCTION FATAL {
  PARAMETER message.
}


// implementation for failureCallback used in non-fatal assertions (EXPECT_*).
LOCAL FUNCTION NONFATAL {
  PARAMETER message.
}


// internal tracker for existing test cases
LOCAL _test_cases IS LEXICON().
LOCAL _test_success IS TRUE.


// helper function for displaying counts of items
LOCAL FUNCTION DisplayCount {
  PARAMETER num.  // number of items to display
  PARAMETER item. // item to pluralize

  LOCAL display IS num + " " + item.

  // simply add s if not 1
  // TODO: consider grammar rules
  IF NOT (num = 1) SET display TO display + "s".
  RETURN display.
}
