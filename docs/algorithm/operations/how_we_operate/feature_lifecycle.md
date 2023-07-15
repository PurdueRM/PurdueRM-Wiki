---
layout: default
title: How to Contribute Code
parent: How Alg Team Operates
grand_parent: Algorithm
nav_order: 1
---


# Team Structure and Workflow

- ************************************************************************How does the algorithm team operate?************************************************************************
    - We operate on a weekly basis, with a team meeting once a week. At each team meeting, we will check-in on every active issue, to ensure progress is being made. Any due/overdue issues will be the primary focus.
- **Feature lifecycle**: If a member wishes to make a code change, they must follow this process:
    - Propose and join an issue on GitLab Issues page (following Issue Lifecycle)
    - Create a separate branch for your changes in your specific project. Make your branch name (and commit messages) indicative of the changes/features you’re working on.
    - Do all your work in this new branch. Commit and push your code to this separate branch.
    - Upon completion of your deliverables and test cases, create a merge request to main and wait for a code review. A reviewer will conduct a ************************Code Review************************ of your code and test cases. Your request will either be improved, or you will receive feedback on what needs to be fixed.
    - After approval, your code will be merged into main. Please mark the issue page as complete. Congrats, your feature is a part of our codebase!
    
    **********************************Issue Lifecycle:********************************** 
    
    - Propose an issue on GitLab, providing a clear title and description outlining the feature. If you would like to join an issue instead, please leave a comment on the specific issue.
    - A team lead will discuss the issue with you and work out a timeframe and deliverables.
    - A member is assigned to the issue, and they are to begin the Feature Lifecycle process.
    
    ************************************Writing Test Cases************************************
    
    - We use the `gtest` framework in conjunction with Travis CI to automate testing our code. Every piece of code should be tested ***************as you write it*************** according to this process:
        - Each project has a skeleton for tests inside its `tests` folder. You will create a new `TEST` function similar to the one below:
            
            ```cpp
            #include <gtest/gtest.h>
            #include <your_package/my_node.hpp>  // Include the header file for your node
            
            // THIS IS THE TEST YOU WRITE FOR my_node
            TEST(MyNodeTest, TestMyNodeFunctionality)
            {
                // Create an instance of the node
                your_package::MyNode node;
            
                // Test the functionality of the node
                // ...
            
                // Example assertions to validate expected behavior
                ASSERT_TRUE(true);
                EXPECT_EQ(2 + 2, 4);
                // ...
            }
            
            // Run all tests
            int main(int argc, char** argv)
            {
                ::testing::InitGoogleTest(&argc, argv);
                return RUN_ALL_TESTS();
            }
            ```
            
        - Your `package.xml` and `CMakeLists.txt` need to be configured to run this test file. If you are not creating a new node/project, you do not need to worry about this.
    
    ********************************Code Evaluations********************************
    
    - During each code evaluation, a team lead will conduct the following:
        - Review and verify test cases (do they cover core functionality and edge cases?)
        - static code analysis (conventions, clean code)
        - memory analysis via valgrind if necessary
    - *For smaller changes, this process is done asynchronously. For larger changes, meeting with a team lead to demonstrate functionality is strictly required.*
