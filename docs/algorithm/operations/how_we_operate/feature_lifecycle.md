---
layout: default
title: How to Contribute Code
parent: How Alg Team Operates
grand_parent: Algorithm
nav_order: 1
---


# Team Structure and Workflow

- **How does the algorithm team operate?**
    - We operate on a weekly basis, with a team meeting once a week. At each team meeting, we will check-in on every active issue, to ensure progress is being made. Any due/overdue issues will be the primary focus.
- **Feature lifecycle**: If a member wishes to make a code change, they must follow this process:
    - Create a new issue if it’s not created yet. Add a good description and select a project label depending on what the issue entails. *Break the issue up into smaller sub-issues if this is a larger project or node*
    - Pick one person to be the CAPTAIN of this issue, and assign the issue to them. Anyone else collaborating on this issue should be pinged in the description. The same applies to sub-issues.
    - Still on the issue page, create a branch and merge request with the button in the top right. Make sure to mark it as a draft (it probably is by default)
        - NOTE: do not assign a code reviewer until your code is complete
    - Begin coding. Make sure to switch to your new branch, and do your code changes in this newly-created branch
    - Upon completing your code, unmark the “draft” checkbox in your merge request. Start a code review by assigning a code reviewer in the right panel
        - NOTE: all users are assigned the “developer” role and are unable to push to main without a code review.
    - The code reviewer will either offer comments / improvements to your code, or they will follow through with the merge and close the request. If you receive feedback, you should make the requested changes and notify the reviewer when you’re done.


    
    **Issue Lifecycle:**
    
    - Propose an issue on GitLab, providing a clear title and description outlining the feature. If you would like to join an issue instead, please leave a comment on the specific issue.
    - A team lead will discuss the issue with you and work out a timeframe and deliverables.
    - A member is assigned to the issue, and they are to begin the Feature Lifecycle process.
    
    **Writing Test Cases**
    
    - We use the `gtest` framework in conjunction with Travis CI to automate testing our code. Every piece of code should be tested **as you write it** according to this process:
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
    
    **Code Evaluations**
    
    - During each code evaluation, a team lead will conduct the following:
        - Review and verify test cases (do they cover core functionality and edge cases?)
        - static code analysis (conventions, clean code)
        - memory analysis via valgrind if necessary
    - *For smaller changes, this process is done asynchronously. For larger changes, meeting with a team lead to demonstrate functionality is strictly required.*
