# Automation Approach [NPHC Quality Engineer Assignment v1.4.pdf]
1.	Design Pattern used for sample test is Page object model.
2.	Robot Framework used for designing the automation framework
3.  Used the Robot Framework, to test the System and create some functional and acceptance tests, leveraging the power of
    the framework to create test cases that use the keywords to interact with the system.
4.  QA_Assignment_Test_Strategy.pdf: Test strategy/approach used while automating the tests/scripts.
5.  QA_Assignment_Test_Execution_Sample.jpg : Sample of command line test execution
6.  QA_Assignment_Execution_Results_Sample(folder): Has sample test results of test execution

**Quick Start (follow the steps to run tests and see results)**
1.	Get latest python3.10 and above with pip installed [**must]
2.	Clone git folder **‘QA_Assignment.git’** to local machine
3.	Root folder is **‘QA_Assignment>’ – All project files/folders parked here.**
    [ Folders with files: Resources, Results, Tests, Utils and 
    Others files: requirements.txt, Readme.md ]

**Once done with above steps then continue in terminal**
1.	pip install virtualenv
2.	To isolate virtual environment, Goto **‘QA_Assignment’> Type Command: ‘python -m venv qa_assess_tests’**
3.	To get isolated environment, Go to folder **‘qa_assess_tests>Scripts’ and Type: ‘activate’**
4.	Go back to root folder **‘QA_Assignment’**
5.	To install all necessary packages, need to run the sample tests, Type: **‘pip install -r requirements.txt’**
6.	Check test web app running locally (http://localhost:8080)

**Run the test and see results**
1.	Type to run all tests: **‘robot --outputdir=Results/ Tests\suiteTest.robot’**
2.	Type to run only api tests: **‘robot --outputdir=Results/ --include=api Tests\suiteTest.robot’**
3.	Type to run only ui tests: **‘robot --outputdir=Results/ --include=ui Tests\suiteTest.robot’**
4.	To check reports, Go to **‘/Results/report.html’**
