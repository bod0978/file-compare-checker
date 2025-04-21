# 檔案比對系統

這個系統用來比對資料庫與檔案是否一致，並顯示比對結果。

📁 檔案比對系統 - 建議專案結構
file-compare-checker/
├── index.html             ← RWD 前端頁面（Tailwind 美化版）
├── calltest.php           ← 呼叫 shell script + 傳回 JSON
├── config.sh   		   ← 核心設定檔 DB、核對資料夾 路徑 
├── check_files.sh         ← 核心 shell script，執行檔案比對
├── README.md              ← 作品說明文件（我們等下會寫）
├── /groupcall/callfile/   ← 檔案目錄（按 GroupID 分資料夾）
└── 📦 其他：未來可加 DB 設定或 logs 等

🔍 功能簡介
根據輸入的編號（GroupID）查詢資料庫與對應的檔案夾比對：

資料庫中的筆數 vs. 檔案數量
資料庫中的號碼是否都有對應的檔案存在
顯示：
資料庫筆數、實際檔案數量
遺漏或多餘的檔案清單
比對是否完全一致 ✅ ❌

🛠 使用技術
前端： HTML + Tailwind CSS（支援 RWD 響應式設計）
後端： PHP（呼叫 Shell Script 並回傳 JSON）
Shell Script： Bash（與 MySQL 互動 + 檔案查核）
資料庫： MySQL（查詢 member 資料表）

▶️ 使用方式
1.確保以下環境：
	Apache/Nginx + PHP
	MySQL 資料庫
	Bash 可執行環境

2.將專案放置於 Web Server 目錄下，例如：/var/www/html/file-compare-checker/

3.修改 config.sh 中的：
	user="root"
	pass="你的密碼"
	db="Groupcall"
	table="member"
	paths="/var/www/html/groupcall/callfile"




