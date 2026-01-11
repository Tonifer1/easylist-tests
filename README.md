## EasyList Tests – Test Automation (Robot Framework)

This repository contains test automation for the EasyList application, built using Robot Framework.
The project includes both API tests and E2E tests, with a clear separation between test cases and reusable resources to support maintainability and future expansion.

## What the project includes

API tests

Authentication and token handling (JWT: access + refresh)

Categories and products (CRUD)

Filtering (e.g. products by category)

Error and edge cases (401, 404, invalid tokens)

Reusable keywords implemented in resource files

E2E tests

Functional testing of the login flow

Browser-based tests using Robot Framework’s Browser library

Tests are executed in headless mode, suitable for CI environments

The EasyList application (frontend and backend) is maintained in separate repositories, and this project is used to test those components.

The project is under active development and serves as a learning and portfolio project focused on test automation.
