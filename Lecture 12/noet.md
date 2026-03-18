Implement & Learn CI: Continuous Integration using github

# Key terms
- Frequently
- Fixing bugs early before merging
- Lint test, build, test and release are the main parts of CI.   

# Shift Left -> DevSecOps
- at developer level: Lint, build, and test
- always use Linter

1. Linting: 
- always setup linter in project 

2. Testing: 
- implement testing

3. Build:  
- Build before pushing the code

--- Use Husky ---
to inforce run all the above before pushing to git

- Jobs are run in parallel


# Create a github actions and make hands on it.


# terms
- jobs: name, work
- steps: uses, with, run
- strategy: matrix feature: to test features on different machines


Production workflows:
- main production branch
- secure main/prod branch
- practice so many scenarios