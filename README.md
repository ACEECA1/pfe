# CV Grading System

An AI-powered talent acquisition platform built for parsing, structuring, and evaluating candidate resumes against job descriptions. It automates heavy HR workloads using NVIDIA Nemotron OCR, advanced LLMs via OpenRouter, and optional automation through n8n.

## 🚀 Features
- **AI Resume Parsing**: Extracts structured data from PDF CVs using NVIDIA Nemotron OCR.
- **Smart Evaluation**: Compares Candidate CVs with Job Descriptions and automatically scores/grades them.
- **Job Description Structuring**: Transforms raw job postings into precise JSON schemas.
- **Robust Authentication**: JWT-based security with Email verifications.
- **Microservice Ready**: Easily integrates with external n8n workflows for advanced pipeline processing.

## 🛠 Tech Stack
- **Backend**: Java 17, Spring Boot 3, Hibernate / Spring Data JPA, Spring Security, MySQL.
- **Frontend**: React, Vite, Nginx.
- **Containerization**: Fully Dockerized for seamless deployment.

## ⚙️ How to Setup and Run

### 1. Pre-requisites
- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
- Git

### 2. Clone the Repository
Because this is a meta-repo containing submodules, ensure you clone recursively:
```bash
git clone --recursive https://github.com/ACEECA1/pfe.git
cd pfe
```
*(If you already cloned normally, run `git submodule update --init --recursive`)*

### 3. Environment Variables
You must configure your environment before spinning up the containers.
1. Copy `.env.example` to `.env` in the root folder for Docker Compose variables:
   ```bash
   cp .env.example .env
   ```
2. Copy `.env.example` to `backend/.env.docker` for the Spring Boot application configuration:
   ```bash
   cp .env.example backend/.env.docker
   ```
3. **CRITICAL FOR PRODUCTION**: Update your new `.env` and `.env.docker` files with real, secure values!
   - Change `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD`.
   - Set a highly secure, random 256-bit string for `JWT_SECRET`.
   - Provide your `OPENROUTER_API_KEY` and `NVIDIA_API_KEY`.
   - Ensure `FRONTEND_URLS` does not use `*` in production; set it to your exact domain.

### 4. Boot up with Docker Compose
To build the images and launch the database, backend, and frontend simultaneously:
```bash
docker-compose up -d --build
```

### 5. Access the Application
Once the containers are running:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080/api/
- **Database**: MySQL is exposed on port 3306.

## 📝 Logging Configuration
Backend logging verbosity can be controlled dynamically via the `.env.docker` file. Adjust variables like `LOGGING_LEVEL_APP=DEBUG` or `LOGGING_LEVEL_HIBERNATE=INFO` and simply restart the backend container to apply.
