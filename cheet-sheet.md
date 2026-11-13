# Cheat Sheet — benben's Neovim

精通路線，按使用頻率排。重點不在記 keymap，在**組合技**。
完整的 what/why 見 `SPEC.md`；這裡只放操作。

## 1. 移動：flash 取代手術式跳字

- `s` + 字母 = 標籤跳躍。搭配 operator 才是精華：
  - `dsab` → `d` `s` 跳到標籤處刪除（跨半頁單鍵刪）
  - `ysab` → 跳到目標 yank
  - `vsab` → 跳到目標選取
- `S`（visual/normal）= treesitter 節點選取：按 `S` 後 `0-9` 逐層擴大
  （var → expression → statement → function）。改參數名、抽區塊靠這個
- `R`（visual/operator）= treesitter search：用 regex 搜 + treesitter 標籤選目標
- `r`（operator-pending）= remote：`dr` 再跳，刪「游標以外」的目標
- `/` 搜尋中按 `<C-s>` 用 flash 標籤取代重複 `n`

## 2. 文字物件：mini.ai × 一切 operator

`f`=function、`c`=class、`o`=block/loop/if、`t`=tag、`u`=function call、
`g`=整個 buffer、`e`=駝峰字、`d`=數字

組合技（`v`/`y`/`d`/`c`/`>`/`=` 都能用）：

- `vaf` 選整個函式、`dif` 刪函式體留簽名
- `cif` 清掉函式體重寫 — 寫 code 最高頻
- `>af` 縮排整個函式、`=af` 重縮排
- `vit` 選 HTML/TSX tag 內容、`dat` 刪整個 tag
- `ciu` 改 function call 參數
- `v2af` 兩層外圍函式（次數可用）

## 3. surround：mini.surround

- Visual 選取 → `gsa` → 輸入 `)` `"` `` ` `` 等
- Normal：`gsaiw"` = 給 word 加引號（順序：`gsa` → textobject → 字元）
- `gsd"` 刪、`gsr'"` 單引號換雙引號、`gsr)]` 括號互換
- `gsf` 跳到下一個 surround、`gsh` 高亮附近 surround

## 4. 貼上與增減：yanky × dial

- `p` 後按 `]y` / `[y` 輪迴 yank ring — 覆蓋錯 register 不用重抓
- `=p` / `=P` 貼上並自動縮排
- `x` 永遠不覆蓋 yank（已改成 `"_x`），放心亂刪
- `<C-a>`/`<C-x>` 不只數字：日期、`true/false`、星期、字母都會增減
- Visual 多行 `<C-a>` 同步增、`g<C-a>` 遞增序列
  （做 1 2 3 4 列表：打 1，選 4 行，`g<C-a>`）

## 5. LSP 流程

- `gd` / `gr` / `gI` / `gy` 走 picker，可多選可 grep
- `<leader>cr` 活預覽 rename：輸入時全文即時變化，Enter 確認
- `<leader>ca` code action（eslint quick fix 在這）
- `]d` / `[d` 跳診斷、`<leader>cd` 看整行、`<leader>xx` 開 trouble 全域看
- `<leader>uh` 切 inlay hints（預設關）
- `:ToggleFormatter` 關單一 buffer 的 format-on-save（改 legacy 檔案用）
- `gK` / `<C-k>`（insert）signature help

## 6. 搜尋與導航：snacks.picker

| Keys | Action |
| --- | --- |
| `<leader><space>` | Smart find files — 首選入口 |
| `<leader>,` | Buffers |
| `<leader>/` | Grep（root） |
| `<leader>sw` | Grep 選取範圍（visual 也可）— 改 API 名先 `viw` 再 `sw` |
| `<leader>ff` / `<leader>fF` | Find files（root / cwd） |
| `<leader>fr` / `<leader>fR` | Recent（cwd / 全部） |
| `<leader>e` / `<leader>fe` | Explorer（root / cwd） |
| `<leader>cs` | 符號大綱 |
| `<leader>cS` | LSP 引用清單 |
| `<leader>uC` | Colorscheme picker |

- `[q` / `]q` quickfix/trouble 輪詢 — grep 完逐項跳
- `<S-h>` / `<S-l>` 換 buffer、`<leader>bd` 關 buffer 不亂版面
- `<leader><tab>n` / `<leader><tab>d` 開/關 tab
- `<C-h/j/k/l>` 換 window、`<leader>-` 上開、`<leader>|` 右開、`<leader>wd` 關

## 7. Git 審 code 流程（用途核心）

- 開檔先看 `]h` / `[h` 跳 hunk，`<leader>gd` 開 inline diff overlay
- `<leader>gp` 預覽 hunk、`<leader>gb` blame
- `<leader>go` 開「該行最後 commit 當時的檔案」
- `<leader>gh` stage hunk、`<leader>gH` 退 hunk、`<leader>gs` stage 整檔
- `<leader>gg` lazygit 浮層做其餘事（commit/rebase/log）
- 跨檔審：`<leader>/` grep → `[q` / `]q` 逐處看

## 8. Agent 協作

- `<leader>yf` 複製 `path#L12`（visual 選區自動 `#L2-L18`）貼給 Claude Code / OpenCode
- `<leader>yp` 同上，絕對路徑
- `<C-/>` 浮層 terminal 跑 agent，`<leader>ft` 開在 cwd
- `ZR` 重啟 nvim 還原 session — 改完 config 不用重開工作區

## 練法建議

一週只練一組：先 flash operator（`ds`/`ys`/`vs`），再 mini.ai 組合
（`cif`/`vaf`），最後 surround。
忘了就 which-key 等 300ms 顯示；`:WhichKey <leader>g` 可單獨查任一前綴。
