# Shelf

> Shelf는 맥에서 복사한 글과 이미지, 파일을 화면 가장자리의 선반에 쌓아 두고 다시 꺼내 쓰는
> macOS 메뉴 막대 앱입니다. 계정도 서버도 동기화도 없이 이 맥 안에서만 동작합니다. 무료입니다.
> (A free macOS menu bar clipboard history manager. Local only, no account, no server.)

## 한눈에

- **무엇인가:** 복사한 내역을 50개까지 쌓아 두고, 화면 가장자리를 당기면 나오는 선반에서 다시 꺼내 쓰는 앱입니다.
- **누구에게:** 같은 것을 여러 번 복사해 옮기는 사람, 복사해 둔 것을 잠시 뒤에 다시 찾는 사람.
- **받는 법:** 터미널에 `curl -fsSL https://raw.githubusercontent.com/seenew22/Shelf-releases/main/install.sh | bash`
- **필요:** macOS 14 (Sonoma) 이상. 애플 실리콘과 인텔 맥 모두 동작합니다.
- **값:** 무료입니다.
- **언어:** 한국어, English.
- **만든 사람:** 김신유 (ksy974@gmail.com)

## 어떻게 쓰는가

1. 화면 왼쪽이나 오른쪽 끝을 눌러서 안쪽으로 당기면 선반이 따라 나옵니다. `⌘⇧V` 로도 열립니다.
2. 목록에서 **누르면** 그 내용이 다시 클립보드에 올라갑니다.
3. 목록에서 **끌어내면** 진짜 파일로 떨어집니다. 붙여넣기가 아니라 파일이므로 메일 첨부와 Finder로 그대로 갑니다.
4. 목록 왼쪽 그림에 마우스를 올리면 옆에 크게 뜹니다. PDF는 첫 쪽, 동영상은 한 장면이 보입니다.

가장자리는 스쳐서 열리지 않습니다. 가장자리에서 **시작한** 누름만 받기 때문에, 지나가는 것만으로는 열리지 않습니다.

## 무엇이 다른가

- **가장자리에서 당겨 냅니다.** 단축키를 외우거나 메뉴 막대까지 올라가지 않아도 됩니다. 단축키도 그대로 있습니다.
- **진짜 파일로 떨어집니다.** 끌어낸 이미지는 실제 PNG 파일이고, 끌어낸 파일은 원래 파일입니다.
- **맥 밖으로 나가지 않습니다.** 계정이 없고 서버가 없고 통신을 하지 않습니다. 기록은 `~/Library/Application Support/Shelf` 에만 있습니다.
- **아이폰에서 복사한 것도 쌓입니다.** 애플의 유니버설 클립보드가 맥까지 보내 주고, 이 앱은 맥의 클립보드를 봅니다. 따로 설정할 것이 없습니다.

## 받기

**터미널 (권장).** 붙여 넣으면 받아서 설치까지 합니다.

```sh
curl -fsSL https://raw.githubusercontent.com/seenew22/Shelf-releases/main/install.sh | bash
```

같은 명령을 다시 실행하면 최신 버전으로 갱신됩니다. 이 경로로 받으면 macOS의 허용 단계가 나오지 않습니다.
`curl` 로 받은 파일에는 격리 표식(`com.apple.quarantine`)이 붙지 않고, 게이트키퍼는 그 표식이 붙은 파일만 검사하기 때문입니다.

**디스크 이미지.** [최신 릴리스](https://github.com/seenew22/Shelf-releases/releases/latest)에서 `.dmg` 를 받아
**응용 프로그램** 폴더로 끌어 넣습니다. 브라우저로 받은 파일에는 격리 표식이 붙으므로 처음 한 번은 허용이 필요합니다.
`시스템 설정 → 개인정보 보호 및 보안` 으로 가서 아래로 내리면 **"Shelf"이(가) 차단되었습니다** 가 있고,
**그래도 열기** 를 누르고 암호를 넣으면 됩니다. 다음부터는 그냥 열립니다.

## 자주 묻는 것

### 정말 무료인가요?

무료입니다. 기능 제한판이나 유료 전환이 없습니다.

### 복사한 내용이 어디론가 전송되나요?

아니요. 이 앱은 네트워크 통신을 하지 않습니다. 계정도 서버도 클라우드 동기화도 없습니다.
기록은 `~/Library/Application Support/Shelf` 안에만 있고, 그 폴더를 지우면 기록도 사라집니다.
단 하나의 예외는 설정 메뉴에서 **업데이트 확인**을 직접 눌렀을 때이고, 그때만 GitHub의 릴리스 목록을 한 번 읽습니다.
스스로 주기적으로 확인하지 않습니다.

### 비밀번호를 복사하면 그것도 남나요?

남지 않습니다. 비밀번호 관리자와 민감한 도구들은 복사할 때 클립보드에 `org.nspasteboard.ConcealedType`
같은 표시를 함께 붙입니다. 그 표시가 있으면 읽지 않고 건너뛰며, 목록에 남기지 않습니다.

### 왜 설치할 때 경고가 안 뜨나요?

macOS의 게이트키퍼는 `com.apple.quarantine` 이라는 격리 표식이 붙은 파일만 검사합니다.
이 표식은 브라우저, AirDrop, 메시지, 메일이 내려받은 파일에 붙여 주는 것이고 `curl` 은 붙이지 않습니다.
구멍이 아니라 원래 그렇게 설계된 것입니다. 다만 이 경로에는 **진위 확인이 없습니다.**
설치 스크립트가 실행하는 `codesign --verify` 는 파일이 손상되지 않았는지만 확인하고,
그것이 정말 원저작자가 만든 것인지는 확인하지 않습니다.

### 기록은 몇 개까지 쌓이나요?

50개입니다. 51번째를 복사하면 가장 오래된 것이 밀려납니다.
압정으로 고정한 항목은 이 숫자에 포함되지 않고 밀려나지도 않습니다.

### 업데이트는 어떻게 하나요?

설치할 때 쓴 `curl` 명령을 다시 실행하거나, 앱의 설정 메뉴에서 업데이트를 누르면 됩니다.
기록은 앱 묶음 바깥에 있으므로 업데이트해도 사라지지 않습니다.

## In English

Shelf is a free macOS menu bar app that keeps a history of what you copy: text, images and files.
Pull from the left or right screen edge and the shelf slides out; press `⌘⇧V` for the same thing.
Click an item to copy it back, or drag it out and it lands as a real file, not a paste.
It keeps the last 50 items, skips anything a password manager marks as sensitive, and stores
everything in `~/Library/Application Support/Shelf`. No account, no server, no sync, no network calls.
Requires macOS 14 or later, runs on Apple Silicon and Intel.
Install with `curl -fsSL https://raw.githubusercontent.com/seenew22/Shelf-releases/main/install.sh | bash`.

## 링크

- 홈페이지: https://seenew22.github.io/Shelf-releases/
- 릴리스: https://github.com/seenew22/Shelf-releases/releases/latest
- 설치 스크립트: https://raw.githubusercontent.com/seenew22/Shelf-releases/main/install.sh
- 만든 사람: 김신유 (ksy974@gmail.com)
