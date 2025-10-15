#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
LEO_CDP_FOLDER="/build/cdp-instance"
BUILD_VERSION="v_0.9.0"
HTTP_ROUTER_KEY="datahub"
JAR_MAIN="leo-observer-starter-${BUILD_VERSION}.jar"

JVM_PARAMS="-Xms256m -Xmx1500m -XX:+TieredCompilation -XX:+UseCompressedOops -XX:+DisableExplicitGC -XX:+UseNUMA -server"

LOG_DIR="${LEO_CDP_FOLDER}/logs"
LOG_FILE="${LOG_DIR}/observer-${HTTP_ROUTER_KEY}.log"
MAX_LOG_DAYS=7  # keep compressed logs for 7 days

# === PREPARE ENVIRONMENT ===
mkdir -p "$LOG_DIR"
cd "$LEO_CDP_FOLDER" || { echo "Folder not found: $LEO_CDP_FOLDER"; exit 1; }

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

echo "[$(timestamp)] === Restarting observer [$HTTP_ROUTER_KEY] ===" >> "$LOG_FILE"

# === LOG ROTATION (once per day) ===
if [ -f "$LOG_FILE" ]; then
  MOD_DATE=$(date -r "$LOG_FILE" +%Y-%m-%d)
  TODAY=$(date +%Y-%m-%d)
  if [ "$MOD_DATE" != "$TODAY" ]; then
    ARCHIVE="${LOG_FILE}.${MOD_DATE}.gz"
    echo "[$(timestamp)] Rotating old log → $ARCHIVE" >> "$LOG_FILE"
    gzip -c "$LOG_FILE" > "$ARCHIVE"
    : > "$LOG_FILE"  # truncate
  fi
fi

# Delete gzipped logs older than N days
find "$LOG_DIR" -type f -name "observer-${HTTP_ROUTER_KEY}.log.*.gz" -mtime +${MAX_LOG_DAYS} -delete

# === PROCESS CONTROL ===
PID=$(pgrep -f "java.*${HTTP_ROUTER_KEY}" || true)
if [ -n "$PID" ]; then
  echo "[$(timestamp)] Stopping existing observer PID $PID..." >> "$LOG_FILE"
  kill -15 "$PID" || true
  sleep 4
fi

# === START NEW PROCESS ===
echo "[$(timestamp)] Starting observer..." >> "$LOG_FILE"
nohup java $JVM_PARAMS -jar "$JAR_MAIN" "$HTTP_ROUTER_KEY" >> "$LOG_FILE" 2>&1 &

echo "[$(timestamp)] Observer [$HTTP_ROUTER_KEY] restarted (PID: $!)" >> "$LOG_FILE"
echo "[$(timestamp)] === Done ===" >> "$LOG_FILE"
# === DONE ===