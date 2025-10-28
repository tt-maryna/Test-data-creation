#!/bin/bash

# Set certificate for SSL verification
export NODE_EXTRA_CA_CERTS="./timetac-dev-ca.crt"

# Collection and environment files
COLLECTION="test_collection.json"
ENVIRONMENT="stage-env.json"

# Define folder-to-data-file mappings
declare -A FOLDER_DATA_MAP=(
    ["timetrackings"]="timetrackings.json"
    ["departments"]="departments.json"
    ["users"]="users.json"
)

# Function to display usage
show_usage() {
    echo "Usage: $0 [folder1] [folder2] [folder3] ..."
    echo ""
    echo "Available folders:"
    for folder in "${!FOLDER_DATA_MAP[@]}"; do
        echo "  - $folder (uses ${FOLDER_DATA_MAP[$folder]})"
    done
    echo ""
    echo "Examples:"
    echo "  $0 users                    # Run only users folder"
    echo "  $0 departments users        # Run departments and users folders"
    echo "  $0 timetrackings departments users  # Run all three folders"
    echo ""
}

# Function to run newman for a specific folder
run_folder() {
    local folder=$1
    local data_file=${FOLDER_DATA_MAP[$folder]}
    
    if [[ -z "$data_file" ]]; then
        echo "❌ Error: Unknown folder '$folder'"
        return 1
    fi
    
    if [[ ! -f "$data_file" ]]; then
        echo "❌ Error: Data file '$data_file' not found for folder '$folder'"
        return 1
    fi
    
    echo "🚀 Running folder: $folder with data file: $data_file"
    echo "▶️  Command: newman run $COLLECTION -e $ENVIRONMENT -d $data_file --folder \"$folder\""
    echo ""
    
    newman run "$COLLECTION" -e "$ENVIRONMENT" -d "$data_file" --folder "$folder"
    
    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        echo "✅ Completed: $folder"
    else
        echo "❌ Failed: $folder (exit code: $exit_code)"
    fi
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    return $exit_code
}

# Main script logic
main() {
    # Check if newman is installed
    if ! command -v newman &> /dev/null; then
        echo "❌ Error: Newman is not installed or not in PATH"
        echo "Install with: npm install -g newman"
        exit 1
    fi
    
    # Check if no arguments provided
    if [[ $# -eq 0 ]]; then
        echo "❌ Error: No folders specified"
        echo ""
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
        echo "❌ Error: Collection file '$COLLECTION' not found"
        exit 1
    fi
    
    if [[ ! -f "$ENVIRONMENT" ]]; then
        echo "❌ Error: Environment file '$ENVIRONMENT' not found"
        exit 1
    fi
    
    echo "📋 Running Newman with:"
    echo "   Collection: $COLLECTION"
    echo "   Environment: $ENVIRONMENT"
    echo "   Folders to run: $*"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
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
    echo "📊 SUMMARY:"
    echo "   Total folders: $total_folders"
    echo "   Successful: $successful_folders"
    echo "   Failed: $failed_folders"
    
    if [[ $failed_folders -gt 0 ]]; then
        exit 1
    fi
}

# Run the main function with all arguments
main "$@"