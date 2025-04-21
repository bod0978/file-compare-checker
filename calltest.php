<?php
header("Content-Type: application/json");
// 取得使用者輸入的編號
$number = isset($_GET["number"]) ? $_GET["number"] : null;
//$number ="100253"; // 假設的測試編號

if (!$number) {
    echo json_encode(["error" => "請提供查詢的編號"]);
    exit;
}

$script_path = "check_files.sh ".$number;

$output = shell_exec("bash $script_path $number 2>&1");

$result = json_decode($output, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode(["error" => "無法解析 JSON，Shell 輸出: $output"],JSON_UNESCAPED_UNICODE);
    exit;
}

echo json_encode([
    "db_count" => $result["db_count"],
    "file_count" => $result["file_count"],
    "missing_files" => $result["missing_files"],
    "extra_files" => $result["extra_files"],
    "all_matched" => $result["all_matched"]
]);
?>
