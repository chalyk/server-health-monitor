🖥️ Server Health Monitor
Ein Bash-Skript zur Überwachung der Systemressourcen eines Linux-Servers.
Überwacht CPU, RAM und Festplattenauslastung und speichert die Ergebnisse automatisch in täglichen Log-Dateien.

📋 Funktionen

CPU-Überwachung — misst die aktuelle Prozessorauslastung
RAM-Überwachung — zeigt genutzten und gesamten Arbeitsspeicher
Festplatten-Überwachung — prüft die Auslastung der Root-Partition
Farbige Terminal-Ausgabe — Grün / Gelb / Rot je nach Auslastung
Automatisches Logging — speichert Ergebnisse in logs/server_health_DATUM.log
Schwellenwert-Warnungen — konfigurierbare Grenzwerte für Warnungen


🚀 Verwendung
bash# Skript ausführbar machen
chmod +x monitor.sh

# Skript starten
./monitor.sh
Beispiel-Ausgabe
==============================================
  Server Health Monitor  |  2026-03-23 14:32:01
==============================================

[OK]     CPU-Auslastung  : 12%
[OK]     RAM-Auslastung  : 54%
[WARNUNG] Festplatte (/) : 87%

----------------------------------------------
Log gespeichert: ./logs/server_health_2026-03-23.log
==============================================

⚙️ Konfiguration
Die Schwellenwerte können direkt im Skript angepasst werden:
bashCPU_WARN=80     # Warnung ab 80% CPU-Auslastung
RAM_WARN=80     # Warnung ab 80% RAM-Auslastung
DISK_WARN=85    # Warnung ab 85% Festplattenauslastung

🔄 Automatisierung mit Cron
Um das Skript automatisch jede Stunde auszuführen:
bash# Crontab öffnen
crontab -e

# Diese Zeile hinzufügen (jede Stunde)
0 * * * * /pfad/zu/monitor.sh

📁 Projektstruktur
server-health-monitor/
├── monitor.sh       # Hauptskript
├── logs/            # Automatisch erstelltes Log-Verzeichnis
│   └── server_health_YYYY-MM-DD.log
└── README.md

🛠️ Voraussetzungen

Linux / macOS (Bash)
Standard-Tools: top, free, df (auf allen Linux-Systemen vorhanden)


👤 Autor
Vladyslav Chalyi
github.com/chalyk
