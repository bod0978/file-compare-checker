#!/bin/bash
source config.sh

Gid="$1"

# 取得資料庫筆數與檔案數量
DB_COUNT=$(mysql -u${user} -p${pass} -D ${db} -se "SELECT COUNT(*) FROM ${table} where GroupID='${Gid}';")
FILE_COUNT=$(ls -1 ${paths}/${Gid}/*.call 2>/dev/null | wc -l)

# 初始化
ALL_MATCHED=true
missing_files=()
extra_files=()

# 找出缺少的檔案
DB_NUMBERS=$(mysql -u${user} -p${pass} -D ${db} -se "SELECT mobile1 FROM member WHERE GroupID = '${Gid}';")
for num in $DB_NUMBERS; do
    file="${paths}/${Gid}/${Gid}_${num}.call"
    if [ ! -f "$file" ]; then
        missing_files+=("${Gid}_${num}.call")
        ALL_MATCHED=false
    fi
done

# 找出多餘的檔案
for file in ${paths}/${Gid}/*.call; do
    filename=$(basename "$file")
    expected=false
    for num in $DB_NUMBERS; do
        if [ "$filename" = "${Gid}_${num}.call" ]; then
            expected=true
            break
        fi
    done
    if [ "$expected" = false ]; then
        extra_files+=("$filename")
        ALL_MATCHED=false
    fi
done

# 將陣列轉為 JSON 陣列格式字串
json_array() {
    local arr=("$@")
    local out="["
    for i in "${!arr[@]}"; do
        out+="\"${arr[$i]}\""
        [ $i -lt $((${#arr[@]} - 1)) ] && out+=","
    done
    out+="]"
    echo "$out"
}

MISSING_JSON=$(json_array "${missing_files[@]}")
EXTRA_JSON=$(json_array "${extra_files[@]}")
MATCHED_JSON=$([ "$ALL_MATCHED" = true ] && echo "true" || echo "false")

# 輸出 JSON 給 PHP
echo "{
  \"db_count\": $DB_COUNT,
  \"file_count\": $FILE_COUNT,
  \"missing_files\": $MISSING_JSON,
  \"extra_files\": $EXTRA_JSON,
  \"all_matched\": $MATCHED_JSON
}"

