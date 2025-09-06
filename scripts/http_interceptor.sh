#!/bin/bash

LOG_PATH="/var/log/nginx/http_intercept.log"
OUTPUT_FILE="intercepted.txt"

# Function: Print last 5 log entries
show_last_entries() {
  echo "Last 5 intercepted HTTP requests:"
  tail -n 5 "$LOG_PATH"
}

# Function: Tail the log live
tail_log() {
  echo "Tracking new HTTP interceptions..."
  tail -f "$LOG_PATH"
}

# Function: Log entries to a file
log_to_file() {
  echo "Logging to $OUTPUT_FILE..."
  tail -f "$LOG_PATH" >> "$OUTPUT_FILE"
}

# Main logic
case "$1" in
  -tail)
    tail_log
    ;;
  -log)
    log_to_file
    ;;
  *)
    show_last_entries
    ;;
esac
