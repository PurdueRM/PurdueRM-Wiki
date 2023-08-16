---
layout: default
title: How to Test Code
parent: How Alg Team Operates
grand_parent: Algorithm
nav_order: 2
---

###  **Writing Test Cases**
   We use the `gtest` framework in conjunction with Travis CI to automate testing our code. Every piece of code should be tested **before or as you write it**. Each project has a skeleton for tests inside its `tests` folder. You will create a new `TEST` function similar to the one below:
            
```cpp
// test/test_your_nodes.cpp
#include <gtest/gtest.h>
#include <your_node1/your_node1.hpp> // Replace with the correct path to your nodes' header files
// #include other node headers as necessary

// Test case for your_node1 functions
TEST(YourNode1Test, TestFunction1) {
    your_node1::YourNode1 node1; // Create an instance of your_node1
    ASSERT_EQ(node1.function1(), expected_value); // Call functions and test their behavior
    // Add more tests for other functions if needed
}
// Add more test cases for other nodes if needed

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```
            
Your `package.xml` and `CMakeLists.txt` need to be configured to run this test file. If you are not creating a new node/project, you do not need to worry about this.

