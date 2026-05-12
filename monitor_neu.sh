#!/bin/bash
# =============================================================
# Server Health Monitor
# Autor: Vladyslav Chalyi
# Beschreibung: Überwacht CPU, RAM und Festplatte eines Servers
#               und speichert die Ergebnisse in einer Log-Datei.
# =============================================================

# --- Konfiguration ---
logdir="./logs"
logfile="$logdir/server_health_$(date +%Y-%m-%d).log"
cpuwarn=80      # Warnung ab 80% CPU-Auslastung
ramwarn=80      # Warnung ab 80% RAM-Auslastung
diskwarn=85     # Warnung ab 85% Festplattenauslastung

# --- Farben für Terminal-Ausgabe ---
red='\033[0;31m'
yellow='\033[1;33m'
green='\033[0;32m'
nc='\033[0m' # No Color

# --- Log-Verzeichnis erstellen falls nicht vorhanden ---
mkdir -p "$logdir"

# --- Zeitstempel ---
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# --- Funktion: Nachricht loggen und ausgeben ---
log() {
    local level="$1"
    local message="$2"
    echo "[$timestamp] [$level] $message" | tee -a "$logfile"
}

# --- Funktion: Status farbig ausgeben ---
print_status() {
    local label="$1"
    local value="$2"
    local warn="$3"

    if [ "$value" -ge "$warn" ]; then
        echo -e "${red}[WARNUNG]${NC} $label: ${red}${value}%${nc}"
    elif [ "$value" -ge $((warn - 15)) ]; then
        echo -e "${yellow}[ACHTUNG]${nc} $label: ${yellow}${value}%${nc}"
    else
        echo -e "${green}[OK]${nc}     $label: ${green}${value}%${nc}"
    fi
}

# =============================================================
# HAUPTPROGRAMM
# =============================================================

echo "=============================================="
echo "  Server Health Monitor  |  $timestamp"
echo "=============================================="
echo ""

# --- CPU-Auslastung messen (Durchschnitt über 1 Sekunde) ---
cpuidle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
cpuusage=$((100 - cpuidel))

# --- RAM-Auslastung ---
ramtotal=$(free -m | awk '/^Mem:/{print $2}')
ramused=$(free -m | awk '/^Mem:/{print $3}')
ramusage=$(( (ramused * 100) / ramtotal ))

# --- Festplatten-Auslastung (Root-Partition) ---
diskusage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

# --- Ergebnisse ausgeben ---
print_status "CPU-Auslastung  " "$cpuusage" "$cpuwarn"
print_status "RAM-Auslastung  " "$ramusage" "$ramwarn"
print_status "Festplatte (/)  " "$diskusage" "$diskwarn"

echo ""
echo "----------------------------------------------"

# --- In Log-Datei schreiben ---
log "INFO" "CPU: ${cpuusage}% | RAM: ${ramusage}% (${ramused}MB / ${ramtotal}MB) | Disk: ${diskusage}%"

# --- Warnungen loggen ---
if [ "$cpuusage" -ge "$cpuwarn" ]; then
    log "WARNUNG" "CPU-Auslastung kritisch: ${cpuusage}%"
fi
if [ "$ramusage" -ge "$ramwarn" ]; then
    log "WARNUNG" "RAM-Auslastung kritisch: ${ramusage}%"
fi
if [ "$diskusage" -ge "$diskwarn" ]; then
    log "WARNUNG" "Festplattenauslastung kritisch: ${diskusage}%"
fi

echo "Log gespeichert: $logfile"
echo "=============================================="
