# CG Pwn Docker Image

위 이미지는 pwnable 문제 풀이용 docker 이미지입니다.

이 repo와 package는 MIT LICENSE가 적용됩니다.

## 이미지 설명

모든 서버는 ssh로 서버에 접근이 가능하며, root와 user01 ~ 20의 유저가 기본 설정되어 있습니다. 사용할만큼 계정 수를 변경하셔도 됩니다.

GDB-peda, python3, pwntools, One-gadget 같은 포너블에 필요한 필수 패키지 또한 설정 되어 있고, 일반 유저(sudo 권한 X)와 root 유저가 모든 환경을 사용할 수 있습니다.

추가적으로 CG 포너블 실습 문제가 각 유저의 홈 디렉토리에 복사되어 있어 편한 실습이 가능합니다.

root 디렉토리에 있는 `psem.sh`를 통해서 추가 유저 생성, gdb 플러그인 스위칭 시스템 설치, 사용자 삭제 등 관리 기능을 사용하실 수 있습니다.

## Thanks to

[@seohojinn](https://github.com/seohojinn) - 이미지 내 문제파일 개발.

## docker 컨테이너 생성

### ubuntu 22.04

```bash
docker run -d -p 2204:22 --name cg-pwn-22.04 ghcr.io/z3r0c0k3/cg-pwn:22.04
```

### ubuntu 20.04

```bash
docker run -d -p 2004:22 --name cg-pwn-20.04 ghcr.io/z3r0c0k3/cg-pwn:20.04
```

### ubuntu 18.04

```bash
docker run -d -p 1804:1804 --name cg-pwn-18.04 ghcr.io/z3r0c0k3/cg-pwn:18.04
```

## ssh 접속

```bash
ssh -p 2204 USERNAME@SERVER_IP # ubuntu 22.04
ssh -p 2004 USERNAME@SERVER_IP # ubuntu 20.04
ssh -p 1804 USERNAME@SERVER_IP # ubuntu 18.04
```

### Default ID, Password

- ROOT
  - ID: root
  - PW: zerocoke
- USER
  - ID: user01 ~ 20
  - PW: abc1234#
