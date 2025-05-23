# Requirements:

### Unit tests
* Write unit tests to check proper functionality of all business logic. Test for both success and failure.
* Write unit tests to sanity check all view controllers and custom views ([country cell](./CountriesChallenge/Views/CountryCell.swift)).
* Bonus points: Write unit tests for the networking code.

# Overall Coverage: 93%

<img width="1920" alt="overall_coverage_93" src="https://github.com/user-attachments/assets/14ec95be-66d0-476f-afef-2c933757e6c3" />

# Solution:
I created 14 Unit Tests.

Unit Tests: 

<img width="1920" alt="14 Tests Total" src="https://github.com/user-attachments/assets/66da69e5-ed25-45e6-bf66-002491be35af" />

Source Code Changes:

* Reworked some functions to modularize guards
* Added getters/setters to some private member variables to allow access from unit tests

CountriesService.swift:

<img width="1920" alt="CountriesService_1" src="https://github.com/user-attachments/assets/2ebe11c2-d4a6-4f5e-ac86-04d724073001" />
<img width="1920" alt="CountriesService_2" src="https://github.com/user-attachments/assets/5b87b889-3f2d-4a54-b19f-5f40328be729" />

CountriesViewController.swift:

<img width="1920" alt="CountriesViewController_Debug" src="https://github.com/user-attachments/assets/93181fe9-b0ab-4584-8f80-c732bf9713f4" />

Dependency Injection -> CountryViewModel for unit testing: 

<img width="1920" alt="Screenshot 2025-05-09 at 11 02 07 PM" src="https://github.com/user-attachments/assets/0ff5c631-fa4e-4c5f-9315-fcb2390b14a5" />

CountryCell.swift: 

<img width="1920" alt="CountryCell" src="https://github.com/user-attachments/assets/b617334b-184e-4c30-a466-fb17c9839403" />
<img width="1920" alt="CountryCell_Debug" src="https://github.com/user-attachments/assets/141c11c3-c8c6-4db2-8943-2d33985d5e9a" />

CountryDetailViewController.swift: 

<img width="1920" alt="CountryDetailViewController" src="https://github.com/user-attachments/assets/41b90bb6-5cc8-4d2a-8c37-150e938232e9" />

Video: 

https://github.com/user-attachments/assets/a3540181-ca6c-4136-8b88-130ec6128a71

### UI tests
* Write UI tests for all the screens (countries list and country detail) to check proper functionality.
* Bonus points: Write UI tests for the search functionality.

# Solution: 

I implemented UI automation tests to: 
  * scroll through every country
  * validate every cell element
  * click every cell and validate details for every country
  * validate search functionality

All UI Tests Video: 

https://github.com/user-attachments/assets/785e624f-2e18-4071-a01a-8509df3fd2bb

# Acceptance criteria:
* A minimum of 80% test coverage is expected. Bonus points for 90%+ coverage.

# NOTES
* The current implementation may require some refactoring to be properly testable.
