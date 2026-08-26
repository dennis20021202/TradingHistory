# TradingHistory / Trade Journal

Trade Journal 是一個 Windows Portable 交易紀錄與盤中決策輔助工具。

## Branch strategy

- `main`：正式發佈 / CI/CD 分支。只放準備發佈的版本。
- `develop`：主要開發分支，日常功能修改先進這裡，再以 PR 合併到 `main`。

## Release flow

1. 在 `develop` 完成功能與驗證。
2. PR 合併到 `main`。
3. CI 在 `main` 驗證 Windows build。
4. 建立 `vX.Y.Z` tag 後，GitHub Actions 自動：
   - 編譯 `TradeJournal.exe`
   - 建立 Portable 發佈包
   - 產生 `latest.json` 更新資訊
   - 建立 GitHub Release 並附上發佈檔

未來 App 內更新將以 GitHub Release / `latest.json` 為來源，不再要求使用者手動下載 ZIP。
