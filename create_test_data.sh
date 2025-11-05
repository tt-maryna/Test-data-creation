#!/bin/bash

################################################################################
# TimeTac API Test Data Generator
################################################################################
# 
# This script automates the creation of test data for TimeTac API endpoints
# using Newman (Postman CLI) with intelligent data relationship management.
#
# Key Features:
# - Smart ID extraction and assignment between related entities
# - Flexible folder execution (run any combination of endpoints)
# - Comprehensive logging with timestamps and visual formatting
# - SSL certificate handling for secure API connections
# - Error handling and graceful fallbacks
#
# Usage Examples:
#   ./create_test_data.sh projects tasks        # Smart assignment workflow
#   ./create_test_data.sh departments users     # Users auto-assign to departments
#   ./create_test_data.sh users                 # Single endpoint execution
#
# Author: Generated for TimeTac API testing infrastructure
# Version: 2.0 with Smart Assignment Features
################################################################################

# Set certificate for SSL verification with TimeTac API
export NODE_EXTRA_CA_CERTS="./timetac-dev-ca.crt"

# Collection and environment files
COLLECTION="test_collection.json"
ENVIRONMENT="stage-env.json"
OUTPUT_FILE="output.txt"

# Define folder-to-data-file mappings (now in test_data/ subdirectory)
declare -A FOLDER_DATA_MAP=(
    ["timetrackings"]="test_data/timetrackings.json"
    ["departments"]="test_data/departments.json"
    ["users"]="test_data/users.json"
    ["tasks"]="test_data/tasks.json"
    ["projects"]="test_data/projects.json"
)

# Logging function
log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" | tee -a "$OUTPUT_FILE"
}

# Log without timestamp (for formatting)
log_plain() {
    echo "$1" | tee -a "$OUTPUT_FILE"
}

# Function to display usage
show_usage() {
    log_plain "Usage: $0 [folder1] [folder2] [folder3] ..."
    log_plain ""
    log_plain "Available folders:"
    for folder in "${!FOLDER_DATA_MAP[@]}"; do
        log_plain "  - $folder (uses ${FOLDER_DATA_MAP[$folder]})"
    done
    log_plain ""
    log_plain "Examples:"
    log_plain "  $0 users                    # Run only users folder"
    log_plain "  $0 departments users        # Run departments and users folders"
    log_plain "  $0 timetrackings departments users  # Run all three folders"
    log_plain ""
}

# Function to extract project IDs from output and set environment variable for smart assignment
extract_project_ids() {
    log "🔍 Extracting project IDs from output..."
    
    # Extract project IDs from the output file using grep and sed
    # Strategy: Find project creation API responses and extract only the newly created project IDs
    # 1. Look for lines containing '"ResourceName":"projects"' (project creation responses)
    # 2. Get the next 10 lines after each match (contains the Results section)
    # 3. Extract all "id":number patterns from those lines
    # 4. Convert to comma-separated list, limit to 10 IDs max
    local project_ids=$(grep -E '"ResourceName":"projects"' -A 10 "$OUTPUT_FILE" | grep -o '"id":[0-9]*' | head -10 | sed 's/"id"://' | tr '\n' ',' | sed 's/,$//')
    
    if [[ -n "$project_ids" ]]; then
        # Convert to JSON array format for Newman global variables
        local ids_array="[${project_ids}]"
        log "📋 Extracted project IDs: $ids_array"
        
        # Set environment variable for Newman to use in collection prerequest scripts
        export EXTRACTED_PROJECT_IDS="$ids_array"
        
        # Also write to a temporary file (backup method, not currently used)
        echo "extracted_project_ids=$ids_array" > temp_extracted_ids.json
        
        log "✅ Project IDs extracted and ready for use"
    else
        log "⚠️  No project IDs found in output"
        # Set fallback array with default project ID for tasks when no projects were created
        export EXTRACTED_PROJECT_IDS="[3]"
    fi
}

# Function to run newman for a specific folder with enhanced logging and smart ID handling
run_folder() {
    local folder=$1
    local data_file=${FOLDER_DATA_MAP[$folder]}
    
    # Validate folder name exists in our mapping
    if [[ -z "$data_file" ]]; then
        log "❌ Error: Unknown folder '$folder'"
        return 1
    fi
    
    # Validate data file exists
    if [[ ! -f "$data_file" ]]; then
        log "❌ Error: Data file '$data_file' not found for folder '$folder'"
        return 1
    fi
    
    log "🚀 Running folder: $folder with data file: $data_file"
    log "▶️  Command: newman run $COLLECTION -e $ENVIRONMENT -d $data_file --folder \"$folder\" --verbose"
    log_plain ""
    
    # Enhanced newman execution with smart ID passing
    # Pass extracted project IDs as global variables for smart assignment in collection prerequest scripts
    if [[ -n "$EXTRACTED_PROJECT_IDS" ]]; then
        # Run with extracted IDs available for smart assignment (e.g., tasks can auto-assign to projects)
        newman run "$COLLECTION" -e "$ENVIRONMENT" -d "$data_file" --folder "$folder" \
            --global-var "extracted_project_ids=$EXTRACTED_PROJECT_IDS" \
            --verbose 2>&1 | tee -a "$OUTPUT_FILE"
    else
        # Run without extracted IDs (first run or no previous extractions)
        newman run "$COLLECTION" -e "$ENVIRONMENT" -d "$data_file" --folder "$folder" \
            --verbose 2>&1 | tee -a "$OUTPUT_FILE"
    fi
    
    local exit_code=${PIPESTATUS[0]}
    
    if [[ $exit_code -eq 0 ]]; then
        log "✅ Completed: $folder"
        
        # Special handling: If this was the projects folder, extract project IDs for future use
        # This enables smart assignment for subsequent task creation
        if [[ "$folder" == "projects" ]]; then
            extract_project_ids
        fi
    else
        log "❌ Failed: $folder (exit code: $exit_code)"
    fi
    
    # Visual separator for readability
    log_plain ""
    log_plain "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_plain ""
    
    return $exit_code
}

# Main script logic
main() {
    # Clear/create output file at the start
    > "$OUTPUT_FILE"
    
    log "🔄 Starting test data creation script..."
    log "📝 Output will be logged to: $OUTPUT_FILE"
    log_plain ""
    
    # Check if newman is installed
    if ! command -v newman &> /dev/null; then
        log "❌ Error: Newman is not installed or not in PATH"
        log "Install with: npm install -g newman"
        exit 1
    fi
    
    # Check if no arguments provided
    if [[ $# -eq 0 ]]; then
        log "❌ Error: No folders specified"
        log_plain ""
        show_usage
        exit 1
    fi
    
    # Check if help is requested
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    # Check if collection and environment files exist
    if [[ ! -f "$COLLECTION" ]]; then
        log "❌ Error: Collection file '$COLLECTION' not found"
        exit 1
    fi
    
    if [[ ! -f "$ENVIRONMENT" ]]; then
        log "❌ Error: Environment file '$ENVIRONMENT' not found"
        exit 1
    fi
    
    log "📋 Running Newman with:"
    log "   Collection: $COLLECTION"
    log "   Environment: $ENVIRONMENT"
    log "   Folders to run: $*"
    log_plain ""
    log_plain "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_plain ""
    
    local total_folders=$#
    local successful_folders=0
    local failed_folders=0
    
    # Run each specified folder
    for folder in "$@"; do
        run_folder "$folder"
        if [[ $? -eq 0 ]]; then
            ((successful_folders++))
        else
            ((failed_folders++))
        fi
    done
    
    # Summary
    log "📊 SUMMARY:"
    log "   Total folders: $total_folders"
    log "   Successful: $successful_folders"
    log "   Failed: $failed_folders"
    log_plain ""
    log "🏁 Script execution completed at $(date '+%Y-%m-%d %H:%M:%S')"
    
    if [[ $failed_folders -gt 0 ]]; then
        exit 1
    fi
}

# Run the main function with all arguments
main "$@"