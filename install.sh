#!/bin/bash
#
# Shelf 한 줄 설치
#
#   curl -fsSL https://raw.githubusercontent.com/seenew22/Shelf-releases/main/install.sh | bash
#
# .dmg 를 브라우저로 받으면 macOS 가 격리 표식을 붙여서, 처음 열 때 시스템 설정까지
# 들어가 허용해야 합니다. 같은 파일을 curl 로 받으면 그 표식이 붙지 않습니다. 브라우저와
# AirDrop 만 붙이기 때문입니다. 그래서 이 길로 설치하면 그 단계가 통째로 없습니다.
#
# 소스는 비공개라 여기서는 쓰지 않습니다. 이미 만들어 올려 둔 것을 받아서 놓기만 합니다.
set -euo pipefail

APP_NAME="Shelf"
RELEASE_API="https://api.github.com/repos/seenew22/Shelf-releases/releases/latest"

say() { printf '▸ %s\n' "$1"; }
die() { printf '✗ %s\n' "$1" >&2; exit 1; }

# --- 쓸 수 있는 맥인지 ---------------------------------------------------------
MAJOR="$(sw_vers -productVersion | cut -d. -f1)"
if [ "$MAJOR" -lt 14 ]; then
	die "macOS 14 (Sonoma) 이상이 필요합니다. 지금은 $(sw_vers -productVersion) 입니다."
fi

# --- 어떤 것을 받을지 ----------------------------------------------------------
say "가장 최근 버전을 확인합니다"
PAYLOAD="$(curl -fsSL "$RELEASE_API")" || die "릴리스 정보를 가져오지 못했습니다. 인터넷 연결을 확인해 주세요."

TAG="$(printf '%s' "$PAYLOAD" | /usr/bin/python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')"
# 디스크 이미지가 아니라 압축 파일을 받습니다. 붙였다 떼는 과정이 없어 더 단순합니다.
URL="$(printf '%s' "$PAYLOAD" | /usr/bin/python3 -c '
import json, sys
assets = json.load(sys.stdin)["assets"]
zips = [a["browser_download_url"] for a in assets if a["name"].endswith(".zip")]
print(zips[0] if zips else "")
')"
[ -n "$URL" ] || die "받을 파일을 찾지 못했습니다."

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

say "내려받습니다: ${TAG}"
curl -fsSL -o "${WORK}/Shelf.zip" "$URL" || die "내려받지 못했습니다."

say "압축을 풉니다"
# ditto 를 쓰는 이유는, 일반 도구가 서명 정보를 잃어버리기 때문입니다.
ditto -x -k "${WORK}/Shelf.zip" "${WORK}/unpacked" || die "압축을 풀지 못했습니다."
BUILT="${WORK}/unpacked/${APP_NAME}.app"
[ -d "$BUILT" ] || die "받은 파일 안에 앱이 없습니다."

# 받다 만 파일로 멀쩡한 앱을 덮어쓰지 않도록 한 번 확인합니다. 이것이 "우리가 만든 것"
# 이라는 보장은 되지 않지만 — 그건 정식 서명을 받아야 가능합니다 — 내용이 도중에
# 끊겼다면 여기서 걸립니다.
codesign --verify --strict "$BUILT" >/dev/null 2>&1 || die "받은 앱이 온전하지 않습니다. 다시 시도해 주세요."

# --- 어디에 놓을지 -------------------------------------------------------------
# 보통은 응용 프로그램 폴더입니다. 다른 자리에 놓아 보려면 SHELF_APP_DIR 을 주면 됩니다.
APP_DIR="${SHELF_APP_DIR:-/Applications}"
if [ ! -w "$APP_DIR" ]; then
	APP_DIR="${HOME}/Applications"
	mkdir -p "$APP_DIR"
	say "응용 프로그램 폴더에 쓸 수 없어 개인 폴더에 놓습니다"
fi
INSTALLED="${APP_DIR}/${APP_NAME}.app"

say "${APP_DIR} 에 놓습니다"
pkill -x "$APP_NAME" 2>/dev/null || true
sleep 0.5

# 지우고 나서 옮기면, 옮기기가 실패했을 때 쓰던 앱이 사라진 채로 끝납니다.
# 옆으로 밀어 두고, 새것이 제자리에 들어간 뒤에 지웁니다.
BACKUP="${INSTALLED}.old"
rm -rf "$BACKUP"
if [ -e "$INSTALLED" ] && ! mv "$INSTALLED" "$BACKUP"; then
	die "기존 앱을 옮길 수 없습니다: ${INSTALLED}"
fi
if mv "$BUILT" "$INSTALLED"; then
	rm -rf "$BACKUP"
else
	rm -rf "$INSTALLED"
	[ -e "$BACKUP" ] && mv "$BACKUP" "$INSTALLED"
	die "새 앱을 놓지 못해 쓰던 것을 되돌렸습니다."
fi

open "$INSTALLED"

cat <<DONE

✓ 설치했습니다 (${TAG})
  메뉴 바 오른쪽에 트레이 모양 아이콘이 생깁니다.

  히스토리 열기   ⌘⇧V
  가장자리에서    화면 왼쪽이나 오른쪽 끝을 눌러서 당기기
  크게 보기       목록 왼쪽 그림에 마우스 올리기

  지울 때는 응용 프로그램 폴더에서 Shelf 를 버리면 됩니다.
DONE
