#!/bin/bash

# Set project directory
PROJECT_DIR="." # Update if your project is in a different directory

# Install dependencies (if needed)
cd "$PROJECT_DIR/accounting_pos" && npm install
cd "$PROJECT_DIR/ecommerce" && npm install

# Build Firebase functions
cd "$PROJECT_DIR/accounting_pos/functions" && npm run build
cd "$PROJECT_DIR/ecommerce/functions" && npm run build

# Deploy functions
firebase deploy --only functions

# Print success message
echo "Firebase functions deployed successfully!"