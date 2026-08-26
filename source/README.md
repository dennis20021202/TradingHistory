# Source bootstrap

`develop` 目前正在匯入 Trade Journal v1.8.1 的完整專案來源。

`source/bundle/part-*.b64` 是一次性的原始碼 bootstrap bundle；GitHub Actions 會將它還原成正常的專案檔案（`main.go`、`sqlite_windows.go`、`web/` 等）並提交回 `develop`。

若需要手動還原，可在 Windows PowerShell 執行：

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\restore-source.ps1
```

還原後即可使用 `build_windows.cmd` 或 `go build` 建置。
