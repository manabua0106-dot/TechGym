#!/bin/bash
# TechGym記事 lint.sh
# 使い方: bash scripts/lint.sh articles/xxx/h2-01.html

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Usage: bash scripts/lint.sh <html-file>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE"
  exit 1
fi

echo "=== TechGym lint.sh ==="
echo "File: $FILE"
echo ""

ERRORS=0

# 1. 禁止語チェック（完全禁止）
echo "--- 1. 禁止語チェック ---"
for word in "こと[がをはにもで。、]" "として[、。]" "という[こ。、]" "といった"; do
  count=$(grep -oP "$word" "$FILE" 2>/dev/null | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "  ❌ 「$(echo $word | sed 's/\[.*//g')」: ${count}件"
    grep -n "$word" "$FILE" 2>/dev/null | head -5
    ERRORS=$((ERRORS + count))
  fi
done

# 指示語チェック（「この記事」「そのまま」除外）
for word in "これは" "これが" "これを" "その[^ま]" "この[^記]"; do
  count=$(grep -oP "$word" "$FILE" 2>/dev/null | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "  ❌ 指示語「$(echo $word | sed 's/\[.*//g')」: ${count}件"
    grep -n "$word" "$FILE" 2>/dev/null | head -3
    ERRORS=$((ERRORS + count))
  fi
done

# 2. pタグチェック
echo ""
echo "--- 2. pタグチェック ---"
ptag_count=$(grep -c "<p>" "$FILE" 2>/dev/null)
if [ "$ptag_count" -gt 0 ]; then
  echo "  ❌ <p>タグ: ${ptag_count}件（pタグ禁止）"
  ERRORS=$((ERRORS + ptag_count))
else
  echo "  ✅ pタグなし"
fi

# 3. 80文字超の文チェック
echo ""
echo "--- 3. 80文字超の文チェック ---"
# HTMLタグを除去してから文をチェック
long_count=$(sed 's/<[^>]*>//g' "$FILE" | grep -oP '[^。]+。' | awk '{if(length($0) > 80) print NR": "length($0)"文字: "$0}' | wc -l)
if [ "$long_count" -gt 0 ]; then
  echo "  ⚠️  80文字超の文: ${long_count}件"
  sed 's/<[^>]*>//g' "$FILE" | grep -oP '[^。]+。' | awk '{if(length($0) > 80) print "  → "length($0)"文字: "substr($0,1,40)"..."}' | head -5
  ERRORS=$((ERRORS + long_count))
else
  echo "  ✅ 80文字超なし"
fi

# 4. 体言止めチェック（「〜を実施。」「〜に対応。」等）
echo ""
echo "--- 4. 体言止めチェック ---"
taitome_count=$(sed 's/<[^>]*>//g' "$FILE" | grep -cP '[^でますすいた]。' 2>/dev/null || echo 0)
# 簡易判定のため誤検出あり。目視確認を推奨

# 5. 景表法リスク表現チェック
echo ""
echo "--- 5. 景表法リスク表現チェック ---"
for word in "No.1" "業界最安" "最安クラス" "圧倒的" "コスパの良さ" "大幅割引" "低価格"; do
  count=$(grep -c "$word" "$FILE" 2>/dev/null)
  if [ "$count" -gt 0 ]; then
    echo "  ⚠️  景表法リスク「$word」: ${count}件"
    grep -n "$word" "$FILE" 2>/dev/null | head -3
    ERRORS=$((ERRORS + count))
  fi
done

# 6. AI定型表現チェック（3回以上で警告）
echo ""
echo "--- 6. AI定型表現チェック ---"
for word in "大きな魅力" "充実しています" "ぴったり" "第一歩" "選ばれています" "仕上がります"; do
  count=$(grep -c "$word" "$FILE" 2>/dev/null)
  if [ "$count" -ge 3 ]; then
    echo "  ⚠️  AI定型「$word」: ${count}件（3回以上）"
    ERRORS=$((ERRORS + 1))
  fi
done

# 結果サマリ
echo ""
echo "=== 結果 ==="
if [ "$ERRORS" -eq 0 ]; then
  echo "✅ lint-check: PASS（エラー0件）"
else
  echo "❌ lint-check: FAIL（エラー${ERRORS}件）"
fi

exit $ERRORS
