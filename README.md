# **FastAPI Book Project — CI/CD, Security & Containerization**

**Project Overview**
This project demonstrates the complete lifecycle of a FastAPI backend application, including:

   - Fixing missing API functionality
   - Implementing automated testing
   - Adding dependency vulnerability scanning
   - Containerizing the application
   - Serving the API securely through Nginx
   - Preparing the system for cloud deployment

The goal was not just to “make it work”, but to apply production-grade DevSecOps practices.
  
 repository: https://github.com/Ahdams/fastapi-book-project
  branch: main

objective:
  primary_goal:
   - Fix failing tests and missing API endpoints
   -  Enforce automated testing and security checks
   -  Prepare the project for production deployment

  success_criteria:
 -  All tests pass locally and in CI
 - CI pipeline is green
 -  Docker image builds successfully
 -  Application runs behind Nginx using Docker Compose

environment:
 local_setup:
    editor: VS Code
    os: Windows
    terminal: PowerShell
    python_versions:
      - initial: 3.14 (unsupported)
      - final: 3.11 / 3.12
    container_runtime: Docker Desktop
    virtualization: WSL 2
![image](https://hackmd.io/_uploads/HkejJbtNbe.png)

steps:

  - step: 1
    name: Repository Setup
    actions:
      - Cloned the repository from GitHub
      - Opened project in VS Code
      - Created and activated a virtual environment (.venv)
    outcome:
      - Isolated Python environment for dependency management
![image](https://hackmd.io/_uploads/BJRXlZYNWx.png)

  - step: 2
    name: Dependency Installation
    actions:
      - Installed dependencies using requirements.txt
      - Installed pytest and pip-audit
    issues_encountered:
      - Python 3.14 incompatibility
    resolution:
      - Installed Python 3.11 and 3.12
      - Recreated virtual environment
    outcome:
      - Stable development environment
![image](https://hackmd.io/_uploads/rkLyWWY4Wl.png)

  - step: 3
    name: Fixing Failing Tests
    problem:
      - Tests failed with HTTP 405 errors
    root_cause:
      - Missing API endpoints
      - Incorrect HTTP methods
    actions:
      - Implemented missing GET and DELETE endpoints
      - Aligned routes with test expectations
    outcome:
      - All pytest tests passed successfully
![pytets](https://hackmd.io/_uploads/Hy7GW-YE-e.png)

  - step: 4
    name: Understanding the Project
    analysis:
      - Identified FastAPI app structure
      - Located main application entry point
      - Understood API versioning (/api/v1)
    outcome:
      - Clear understanding of request flow and routing

  - step: 5
    name: CI Pipeline Implementation
    tool: GitHub Actions
    triggers:
      - Pull request to main
      - Push to main
      - Scheduled daily scan
    pipeline_steps:
      - Checkout repository
      - Setup Python environment
      - Install dependencies
      - Run pytest
      - Run pip-audit
      - Build Docker image
    outcome:
      - CI pipeline passes with green status
![pr checks](https://hackmd.io/_uploads/H1KLWWKE-e.png)

  - step: 6
    name: Security Auditing
    tool: pip-audit
    issues_found:
      - Vulnerable dependencies (h11, urllib3, starlette)
    actions:
      - Identified transitive dependencies
      - Updated dependency versions
      - Re-ran security scans
    outcome:
      - No known vulnerabilities detected
![image](https://hackmd.io/_uploads/H16MfZt4-l.png)

  - step: 7
    name: Dockerization
    approach:
      - Multi-stage Docker build
    actions:
      - Created Dockerfile at project root
      - Used Python 3.11 slim images
      - Ran application as non-root user
    outcome:
      - Lightweight and secure Docker image
      
     **validation**  
                   docker build -t fastapi-app .
       
                  docker run -p 8000:8000 fastapi-app
                                                        
![docker 2](https://hackmd.io/_uploads/rkWHVWtEbe.png)

  - step: 8
    name: Reverse Proxy Setup
    tools:
      - Docker Compose
      - Nginx
    actions:
      - Created docker-compose.yml
      - Configured Nginx to proxy requests to FastAPI
      - Exposed only Nginx to host
    outcome:
      - FastAPI accessible through Nginx on port 80
![nginx](https://hackmd.io/_uploads/ByJar-KV-x.png)

  - step: 9
    name: Validation
    checks:
      - Tests pass locally
      - CI pipeline green
      - Docker containers start successfully
      - API accessible via Nginx
    outcome:
      - Task completed successfully

 ### lessons_learned:
  - Importance of Python version compatibility
  - CI catches issues early
  - Security vulnerabilities can come from transitive dependencies
  - Docker networking isolates services effectively
  - Documentation is as important as implementation

## Next Phase: AWS Deployment

 Now that the project is:
 
  - Tested
  - Secured
  - Containerized
  - Reverse-proxied
  - We are ready to deploy this properly on AWS.
