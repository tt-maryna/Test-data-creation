#!/bin/bash

# Set certificate for SSL verification
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

# Function to run newman for a specific folder
run_folder() {
    local folder=$1
    local data_file=${FOLDER_DATA_MAP[$folder]}
    
    if [[ -z "$data_file" ]]; then
        log "❌ Error: Unknown folder '$folder'"
        return 1
    fi
    
    if [[ ! -f "$data_file" ]]; then
        log "❌ Error: Data file '$data_file' not found for folder '$folder'"
        return 1
    fi
    
    log "🚀 Running folder: $folder with data file: $data_file"
    log "▶️  Command: newman run $COLLECTION -e $ENVIRONMENT -d $data_file --folder \"$folder\" --verbose"
    log_plain ""
    
    # Run newman with verbose output to capture request/response details
    newman run "$COLLECTION" -e "$ENVIRONMENT" -d "$data_file" --folder "$folder" \
        --verbose 2>&1 | tee -a "$OUTPUT_FILE"
    
    local exit_code=${PIPESTATUS[0]}
    
    if [[ $exit_code -eq 0 ]]; then
        log "✅ Completed: $folder"
    else
        log "❌ Failed: $folder (exit code: $exit_code)"
    fi
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