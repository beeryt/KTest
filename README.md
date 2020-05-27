# KTest
**Note: this project is not affiliated with either googletest or KSP-KOS.**


*KTest* is a unit test framework inspired by [gtest](https://github.com/google/googletest/blob/master/googletest/docs/primer.md) for use with [kOS - Kerbal Operating System](https://github.com/KSP-KOS/KOS).

## Why KTest?
Sometimes our kOS scripts don't work. KTest provides a framework for writing unit tests directly in kerboscript, the programming language of [kOS](https://github.com/KSP-KOS/KOS). It aims to provide a simple, lightweight API so you can spend spend less time writing tests and more time launching rockets!

## Getting Started
### Installation
To get started using KTest simply place the KTest folder somewhere alongside your kOS scripts.

### Running the example
Assuming the KTest folder is located at 0:/KTest open a kOS terminal and type:
```
CD("0:/KTest").
RUN example_lib_ktest.
```
More generally, the examples provided have an optional *path_to_ktest* parameter to specify where to find the KTest library:
```
RUN example_lib_ktest("/path/to/lib_ktest").
```
You should get output which looks like the following:
```
[==========] Running 3 tests from 2 test cases.
[----------] Global test environment set-up.
[----------] 2 tests from MyTestSuite.
[ RUN      ] MyTestSuite.MyTestA
[       OK ] MyTestSuite.MyTestA
[ RUN      ] MyTestSuite.MyTestB
[       OK ] MyTestSuite.MyTestB
[----------] 2 tests from MyTestSuite.

[----------] 1 test from FaultySuite.
[ RUN      ] FaultySuite.Fault
Expected equality of these values:
  1
  2
[  FAILED  ] FaultySuite.Fault
[----------] 1 test from FaultySuite.

[----------] Global test environment tear-down.
[==========] 3 tests from 2 test cases ran.
[  PASSED  ] 2 tests.
[  FAILED  ] 1 test, listed below:
[  FAILED  ] FaultySuite.Fault

 1 FAILED TEST
```

### Writing your first test
In your preferred kOS editor, create a new script file for your tests.
#### Include the KTest library files in your script
```
RUNPATH("/path/to/lib_ktest").
```
#### Declare one or more tests associated with test suite
```
TEST("TestSuite", "TestName", {
  ASSERT_TRUE(TRUE).
}).
```
#### Run all tests
```
RUN_ALL_TESTS().
```

#### Run your script
As with the example above we can simply run our new tests with:
```
RUN name_of_script.
```
You should see output which looks like the following:
```
[==========] Running 1 test from 1 test case.
[----------] Global test environment set-up.
[----------] 1 test from TestSuite.
[ RUN      ] TestSuite.TestName
[       OK ] TestSuite.TestName
[----------] 1 test from TestSuite.

[----------] Global test environment tear-down.
[==========] 1 test from 1 test case ran.
[  PASSED  ] 1 test.
```

## Concepts
### Assertions
Assertions are the meat and potatoes of the KTest framework.
You can use assertions to test the behavior of your script.

|    Assertion    | Predicate |
| --------------- | --------- |
| ASSERT_EQ(a, b) | a = b  |
| ASSERT_NE(a, b) | a <> b |
| ASSERT_LT(a, b) | a < b  |
| ASSERT_LE(a, b) | a <= b |
| ASSERT_GT(a, b) | a > b  |
| ASSERT GE(a, b) | a >= b |
| ASSERT_TRUE(a)  | a      |
| ASSERT_FALSE(a) | NOT a  |

### TEST
*TEST* is used to declare a new *test* within a *test case*.
```
FUNCTION TEST {
  PARAMETER testCase.   // A unique identifier for which test case this test is part of.
  PARAMETER testName.   // A unique identifier for the name of this specific test.
  PARAMETER testBody.   // A function delegate which runs the actual test.
  ...
}
```
#### Usage
```
// using anonymous functions
TEST("MyTestSuite", "MyTestA", {
  // test body goes here
}).

// using explicit delegates
TEST("MyTestSuite", "MyTestB", mytestb_implementation@).
FUNCTION mytestb_implementation {
  // test body goes here
}
```

### RUN_ALL_TESTS
*RUN_ALL_TESTS* will run all of your registered *test cases* and their respective *tests*.
#### Usage
```RUN_ALL_TESTS().```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests and documentation as appropriate.
