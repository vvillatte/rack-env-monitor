# 📘 **Rack Environment Monitor — Project Overview**

The **Rack Environment Monitor** is a lightweight, modular, and secure application suite designed to measure, store, and visualize environmental conditions inside a home network rack. It combines embedded sensing, host automation, data processing, and optional dashboard capabilities in a clean, scalable architecture.

This repository contains all components required to deploy the system on a Linux host, including firmware, automation scripts, and the Python service responsible for data collection and processing.

---

## 🧭 **Purpose**

The project provides:

- Real‑time temperature and humidity monitoring  
- Local OLED display output  
- Structured JSON data streaming from the Arduino  
- Secure host‑side automation and service setup  
- Python‑based data collection and processing  
- A foundation for dashboards, alerts, and long‑term storage  

The system is intentionally designed to be **lightweight**, **modern**, and **easy to maintain**, while allowing future expansion without architectural rewrites.

---

## 🗂️ **Repository Structure**

```
rack-env-monitor/
├── Arduino/        # Embedded firmware for sensing and display
│   └── README.md   # Arduino-specific documentation
├── Bash/           # Host automation and setup scripts
│   └── README.md   # Bash-specific documentation
├── Python/         # Data collection, processing, and service logic
│   └── README.md   # Python-specific documentation (optional)
├── .github/        # CI workflows and branch rulesets
└── README.md        # Project-level documentation (this file)
```

Each top‑level folder is a **self‑contained subsystem** with its own responsibilities and documentation.

---

## 🧩 **Architecture**

The Rack Environment Monitor follows a **layered hybrid architecture**, where each layer performs one job extremely well and exposes a clean interface to the next.

### **1. Arduino Layer — Real‑Time Sensing**
- Reads temperature and humidity sensors  
- Drives the OLED display  
- Streams structured JSON over serial  
- Contains no business logic or storage  
- Designed for reliability and simplicity  

### **2. Bash Layer — Host Automation**
- Creates hardened service users  
- Configures permissions (e.g., serial access)  
- Sets up directory structures under `/srv/`  
- Installs Python wheels  
- Deploys systemd services and timers  

This layer ensures the host is configured securely and predictably.

### **3. Python Layer — Data Collection & Processing**
- Reads JSON from the Arduino  
- Validates and normalizes sensor data  
- Adds timestamps  
- Stores data in a lightweight database (SQLite recommended)  
- Provides APIs for dashboards or external integrations  
- Runs as a systemd service under a non‑login user  

This is the heart of the application suite.

### **4. Optional Future Layers**
The architecture supports clean expansion:

- HTMX/Tailwind dashboard served via FastAPI  
- MQTT publishing  
- Prometheus exporters  
- Webhooks and alerts  
- InfluxDB or TimescaleDB for long‑term storage  
- Multiple sensor nodes  

The system is intentionally modular so new components can be added without disrupting existing ones.

---

## 🟦 **Technologies**

The project uses a carefully selected set of lightweight, modern technologies:

### **Embedded**
- Arduino C++  
- I²C/SPI sensors  
- Serial JSON output  

### **Host Automation**
- Bash  
- systemd  
- Linux service users  
- FHS‑compliant directory layout (`/srv/rack-env-monitor`)  

### **Data Processing**
- Python 3  
- Poetry for packaging  
- Pydantic for validation  
- SQLite for storage  
- FastAPI (optional) for APIs and dashboards  

### **Dashboard (optional)**
- FastAPI  
- HTMX  
- TailwindCSS  

This stack avoids heavy frameworks while remaining modern and maintainable.

---

## 🔧 **Development Workflow**

Development is driven by **Action Items** from the project plan.  
Each Action Item corresponds to a working branch.

### **Branch Naming Convention**
All working branches must follow:

```
new/<item-number>-<short-description>
update/<item-number>-<short-description>
fix/<item-number>-<short-description>
feature/<item-number>-<short-description>
```

Examples:

```
new/12-add-oled-support
fix/7-dht22-timeout
update/3-refactor-display-driver
feature/21-prometheus-exporter
```

### **Working Branch Rules**
- Developers may push commits freely  
- Force‑pushes are blocked  
- Deletion is blocked  
- Linear history enforced  
- Naming conventions enforced via rulesets  
- No PR requirement  

Working branches are flexible and designed for active development.

### **Main Branch Rules**
The `main` branch is strictly protected:

- No direct commits  
- No force‑push  
- No deletion  
- All changes must come through a Pull Request  
- PRs require approval  
- Status checks must pass  
- Conversations must be resolved  
- Linear history enforced  

This ensures a clean, auditable, production‑ready main branch.

---

## 🧪 **Continuous Integration (Optional)**

The repository supports optional CI workflows such as:

- Arduino compilation checks  
- Python linting and type checking  
- Branch naming enforcement  
- PR validation  
- Release packaging  

These can be added under `.github/workflows/`.

---

## 🔐 **Security Considerations**

The project follows modern security best practices:

- Non‑login service user (`svc-runner`)  
- Minimal permissions (only `dialout`)  
- Root‑owned entrypoint scripts  
- No direct execution of code from the repo  
- Wheel‑based Python deployment  
- systemd sandboxing options available  

This ensures the monitoring service is safe to run on production hosts.

---

## 📄 **Contributing**

Contributions follow the Action Item workflow described above.  
New subsystems should be added as top‑level folders with their own README.

---
End of document
