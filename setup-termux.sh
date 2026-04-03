#!/data/data/com.termux/files/usr/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' 

clear

echo -e "${RED}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║            REPORT TOOL - TERMUX SETUP                     "
echo "║              Instagram Report Tool                         "
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOL_DIR="$SCRIPT_DIR"
MAIN_SCRIPT="$TOOL_DIR/main.py"


if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "${RED}[!] Error: main.py not found in $TOOL_DIR${NC}"
    echo -e "${YELLOW}[*] Make sure this script is in the same folder as main.py${NC}"
    exit 1
fi

echo -e "${CYAN}[*] Tool directory: ${WHITE}$TOOL_DIR${NC}"
echo ""


echo -e "${YELLOW}[1/4] Updating Termux packages...${NC}"
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1
echo -e "${GREEN}[✓] Packages updated${NC}"


echo -e "${YELLOW}[2/4] Checking Python...${NC}"
if ! command -v python &> /dev/null; then
    echo -e "${CYAN}    Installing Python...${NC}"
    pkg install python -y > /dev/null 2>&1
fi
PYTHON_VERSION=$(python --version 2>&1)
echo -e "${GREEN}[✓] $PYTHON_VERSION${NC}"


echo -e "${YELLOW}[3/4] Installing dependencies...${NC}"
pip install --upgrade pip > /dev/null 2>&1

if [ -f "$TOOL_DIR/requirements.txt" ]; then
    pip install -r "$TOOL_DIR/requirements.txt" -q
else
    pip install requests argon2-cffi -q
fi
echo -e "${GREEN}[✓] Dependencies installed${NC}"


echo -e "${YELLOW}[4/4] Creating launcher...${NC}"

LAUNCHER_PATH="/data/data/com.termux/files/usr/bin/report"

cat > "$LAUNCHER_PATH" << EOF
#!/data/data/com.termux/files/usr/bin/bash
cd "$TOOL_DIR"
python main.py "\$@"
EOF

chmod +x "$LAUNCHER_PATH"

echo -e "${GREEN}[✓] Launcher created${NC}"


echo -e "${GREEN}[✓] Setup complete (no shell config modified)${NC}"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}           INSTALLATION COMPLETE!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${WHITE}You can now run the tool from ANYWHERE by typing:${NC}"
echo ""
echo -e "    ${CYAN}report${NC}   - Start the tool"
echo ""
echo -e "${RED}Press Enter to launch the tool now...${NC}"
read


cd "$TOOL_DIR"
python main.py
