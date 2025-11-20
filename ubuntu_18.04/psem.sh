#!/bin/bash

# ========================================================
#  Pwnable Study Environment Manager (v3.0)
#  - Create User / Delete User / Update Existing User
#  - Tools: GDB-PEDA, Pwndbg, GEF
#  - Config: UTF-8 Locale, Alias Switcher
# ========================================================

# 1. root 권한 확인
if [ "$EUID" -ne 0 ]; then
  echo "[-] 이 스크립트는 root 권한으로 실행해야 합니다. sudo를 사용하여 실행해주세요."
  exit 1
fi

# ========================================================
#  [공통 함수] 환경 설정 및 도구 설치 (setup_environment)
#  -> 생성된 유저나 기존 유저에게 모두 사용됨
# ========================================================
function setup_environment() {
    local TARGET_USER=$1
    local USER_HOME="/home/$TARGET_USER"

    echo "[*] '$TARGET_USER' 사용자를 위한 환경 설정을 시작합니다..."

    # 1. 디버거 도구 설치 (PEDA, Pwndbg, GEF)
    echo "  -> 디버거 도구(PEDA, Pwndbg, GEF) 준비 중..."

    # (1) PEDA
    if [ -d "/root/peda" ]; then
        cp -r /root/peda "$USER_HOME/peda"
    else
        [ ! -d "$USER_HOME/peda" ] && git clone https://github.com/longld/peda.git "$USER_HOME/peda"
    fi

    # (2) Pwndbg
    if [ -d "/root/pwndbg" ]; then
        cp -r /root/pwndbg "$USER_HOME/pwndbg"
    else
        [ ! -d "$USER_HOME/pwndbg" ] && git clone https://github.com/pwndbg/pwndbg.git "$USER_HOME/pwndbg"
    fi

    # (3) GEF
    wget -O "$USER_HOME/.gdbinit-gef.py" -q https://gef.blah.cat/py


    # 2. .bashrc 설정 (Locale & Alias) - 중복 방지 체크 포함
    echo "  -> .bashrc 환경 설정 적용 중..."
    
    if grep -q "GDB Debugger Switcher" "$USER_HOME/.bashrc"; then
        echo "     (이미 설정되어 있어 건너뜁니다.)"
    else
        cat << EOF | tee -a "$USER_HOME/.bashrc" > /dev/null

# --- Locale Setting for GEF (Unicode Support) ---
export LC_ALL=C.UTF-8
# ----------------------------------------------

# --- GDB Debugger Switcher ---
alias init-peda='echo "source ~/peda/peda.py" > ~/.gdbinit && echo "[+] PEDA Configured."'
alias init-gef='echo "source ~/.gdbinit-gef.py" > ~/.gdbinit && echo "[+] GEF Configured."'
alias init-pwndbg='echo "source ~/pwndbg/gdbinit.py" > ~/.gdbinit && echo "[+] Pwndbg Configured."'
# -----------------------------
EOF
    fi

    # 3. 초기값 Pwndbg 설정
    echo "source ~/pwndbg/gdbinit.py" | tee "$USER_HOME/.gdbinit" > /dev/null

    # 4. 문제 파일 복사
    echo "  -> PWNABLE 디렉터리 복사 중..."
    [ -d "/root/PWNABLE" ] && cp -r /root/PWNABLE "$USER_HOME/PWNABLE"
    [ -d "/root/PWNABLE2" ] && cp -r /root/PWNABLE2 "$USER_HOME/PWNABLE2"

    # 5. 권한 일괄 설정 (마지막에 한 번에 수행)
    echo "  -> 소유권 변경 중..."
    chown -R "$TARGET_USER":"$TARGET_USER" "$USER_HOME"

    echo "[+] '$TARGET_USER' 환경 설정 완료!"
}


# ========================================================
#  [메뉴 1] 사용자 생성 (create_user)
# ========================================================
function create_user() {
    echo ""
    echo ">>> [1. 사용자 생성 모드]를 시작합니다."
    read -p "새로 생성할 사용자 이름을 입력하세요: " NEW_USERNAME

    if [ -z "$NEW_USERNAME" ]; then
        echo "[-] 사용자 이름이 입력되지 않았습니다."
        exit 1
    fi

    # 사용자 중복 확인
    if id "$NEW_USERNAME" &>/dev/null; then
        echo "[-] 사용자 $NEW_USERNAME 은(는) 이미 존재합니다."
        exit 1
    fi

    # 계정 생성
    useradd -m -s /bin/bash "$NEW_USERNAME"
    if [ $? -ne 0 ]; then
        echo "[-] 사용자 생성 실패."
        exit 1
    fi

    # 비밀번호 설정
    echo "$NEW_USERNAME:abc1234#" | chpasswd
    echo "[+] 사용자 계정 생성 및 비밀번호 설정 완료 (abc1234#)"

    # 공통 함수 호출로 환경 세팅
    setup_environment "$NEW_USERNAME"
    
    echo "========================================================"
    echo " [성공] 모든 작업이 완료되었습니다."
    echo "========================================================"
}


# ========================================================
#  [메뉴 2] 사용자 삭제 (delete_user)
# ========================================================
function delete_user() {
    echo ""
    echo ">>> [2. 사용자 삭제 모드]를 시작합니다."
    read -p "삭제할 사용자 이름을 입력하세요: " TARGET_USER

    if [ -z "$TARGET_USER" ]; then
        echo "[-] 사용자 이름이 입력되지 않았습니다."
        exit 1
    fi

    if ! id "$TARGET_USER" &>/dev/null; then
        echo "[-] 오류: 사용자 '$TARGET_USER'을(를) 찾을 수 없습니다."
        exit 1
    fi

    if [ "$TARGET_USER" == "root" ]; then
        echo "[-] 오류: root 사용자는 삭제할 수 없습니다."
        exit 1
    fi

    echo "!!! 경고 !!! 사용자 '$TARGET_USER' 및 홈 디렉터리가 영구적으로 삭제됩니다."
    read -p "정말 삭제하시겠습니까? (y/n): " CONFIRM

    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "[-] 취소되었습니다."
        exit 0
    fi

    # 프로세스 종료 후 삭제
    if pgrep -u "$TARGET_USER" > /dev/null; then
        echo "[*] 실행 중인 프로세스 종료 중..."
        pkill -KILL -u "$TARGET_USER"
        sleep 1
    fi

    userdel -r "$TARGET_USER" 2>/dev/null
    echo "[+] 사용자 '$TARGET_USER' 삭제 완료."
}


# ========================================================
#  [메뉴 3] 기존 사용자 환경 업데이트 (update_existing_user)
# ========================================================
function update_existing_user() {
    echo ""
    echo ">>> [3. 기존 사용자 환경 업데이트 모드]를 시작합니다."
    read -p "업데이트할 사용자 이름을 입력하세요: " TARGET_USER

    if [ -z "$TARGET_USER" ]; then
        echo "[-] 사용자 이름이 입력되지 않았습니다."
        exit 1
    fi

    # 사용자 존재 여부 확인
    if ! id "$TARGET_USER" &>/dev/null; then
        echo "[-] 오류: 사용자 '$TARGET_USER'을(를) 찾을 수 없습니다. 먼저 생성해주세요."
        exit 1
    fi

    if [ "$TARGET_USER" == "root" ]; then
        echo "[-] 주의: root 계정 설정은 권장하지 않습니다."
        read -p "그래도 진행하시겠습니까? (y/n): " ROOT_CONFIRM
        if [[ "$ROOT_CONFIRM" != "y" && "$ROOT_CONFIRM" != "Y" ]]; then
            exit 0
        fi
    fi

    # 공통 함수 호출
    setup_environment "$TARGET_USER"

    echo "========================================================"
    echo " [성공] 사용자 '$TARGET_USER'의 환경이 업데이트되었습니다."
    echo "========================================================"
}


# ========================================================
#  메인 메뉴
# ========================================================
echo "========================================================"
echo "  Pwnable Study Environment Manager"
echo "========================================================"
echo " 1. 새 사용자 생성 및 환경 세팅 (Create)"
echo " 2. 사용자 삭제 (Delete)"
echo " 3. 기존 사용자 환경 업데이트 (Update Tools)"
echo "========================================================"
read -p "원하는 작업 번호를 입력하세요 (1-3): " CHOICE

case "$CHOICE" in
    1)
        create_user
        ;;
    2)
        delete_user
        ;;
    3)
        update_existing_user
        ;;
    *)
        echo "[-] 잘못된 입력입니다."
        exit 1
        ;;
esac