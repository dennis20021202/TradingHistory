# In-app updater design

目標：使用者不再手動下載 ZIP。App 啟動後或由使用者按「檢查更新」，直接從 GitHub Release 取得正式版本。

## Stable endpoint

GitHub Release 會固定上傳 `latest.json`，未來 App 可讀：

`https://github.com/dennis20021202/TradingHistory/releases/latest/download/latest.json`

Manifest 內容包含：
- `version`
- `executable.url`
- `executable.sha256`
- Portable fallback URL / SHA256
- Release page

## Recommended update flow

1. App 讀取目前 `appVersion`。
2. GET `latest.json`，比較 semantic version。
3. 若有新版，顯示版本與 Release Notes。
4. 使用者確認後下載新的 `TradeJournal.exe` 到 `.update/TradeJournal.new.exe`。
5. 驗證 SHA-256 必須與 manifest 相同。
6. 啟動獨立 updater/helper，關閉目前 App。
7. helper 將舊 EXE 備份為 `.update/TradeJournal.old.exe`，再原子替換主 EXE。
8. 重新啟動 Trade Journal。
9. 確認新版可啟動後刪除舊 EXE。

## Data safety

Updater 永遠不能覆蓋：
- `data/`
- `backups/`
- `exports/`

SQLite schema migration 應由新版程式啟動時完成，且 migration 前先建立 DB backup。

## Release convention

- `develop`：日常開發。
- `main`：正式候選版本。
- Git tag：`vX.Y.Z`。
- tag 必須與 `main.go` 的 `appVersion` 完全一致，否則 Release workflow 失敗。
