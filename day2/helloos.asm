ORG 0x7c00        ; このプログラムがどこに読み込まれるか

; FAT12フォーマットフロッピーディスクのための記述
JMP entry
DB  0x90
DB "HELLOIPL"     ; ブートセクタ名
DW 512            ; 1セクタの大きさ
DB 1              ; クラスタの大きさ
DW 1              ; FATがどこから始まるか
DB 2              ; FATの個数
DW 224            ; ルートディレクトリ領域の大きさ
DW 2880           ; ドライブの大きさ
DB 0xf0           ; メディアタイプ
DW 9              ; FAT領域の長さ
DW 18             ; 1トラックにいくつのセクタがあるか
DW 2              ; ヘッドの数
DD 0              ; パーティションは使わない
DD 2880           ; ドライブの大きさ
DB 0, 0, 0x29     ; よくわからない値
DD 0xffffffff     ; ボリュームシリアル番号
DB "HELLO-OS   "  ; ディスクの名前
DB "FAT12   "     ; フォーマットの名前
RESB 18           ; 18バイト空ける

entry:
    MOV AX, 0     ; レジスタ初期化
    MOV SS, AX
    MOV SP, 0x7c00
    MOV DS, AX
    MOV ES, AX

    MOV SI, msg
putloop:
    MOV AL, [SI]
    ADD SI, 1     ; SIに1を足す
    CMP AL, 0
    JE fin
    MOV AH, 0x0e  ; 1文字表示ファンクション
    MOV BX, 15    ; カラーコード
    INT 0x10      ; ビデオBIOS呼び出し
    JMP putloop
fin:
    HLT           ; 何かあるまでCPUを停止
    JMP fin       ; infinite loop
msg:
    DB 0x0a, 0x0a ; 改行2つ
    DB "hello, world"
    DB 0x0a       ; 改行
    DB 0

    RESB 0x7dfe-($-$$) ; 0x7dfeまで0x00で埋める
    DB 0x55, 0xaa

; その他の記述
DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
RESB 4600
DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
RESB 1469432
