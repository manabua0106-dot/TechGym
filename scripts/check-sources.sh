#!/bin/bash
# TechGym check-sources.sh
# service-info.mdのデータと記事HTMLの整合性をチェックする
# 使い方: bash scripts/check-sources.sh articles/xxx/final.html

FILE="$1"
SERVICE_INFO=".claude/rules/service-info.md"

if [ -z "$FILE" ]; then
  echo "Usage: bash scripts/check-sources.sh <html-file>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE"
  exit 1
fi

if [ ! -f "$SERVICE_INFO" ]; then
  echo "Error: service-info.md not found at $SERVICE_INFO"
  exit 1
fi

echo "=== TechGym check-sources.sh ==="
echo "File: $FILE"
echo ""

ERRORS=0

# 1. アフィリURL整合性チェック
echo "--- 1. アフィリURL整合性チェック ---"

# RUNTEQ
if grep -q "af.moshimo.com" "$FILE"; then
  # RUNTEQのa_id
  if grep -q "a_id=5222640" "$FILE"; then
    runteq_url=$(grep -oP 'a_id=5222640[^"]*' "$FILE" | head -1)
    expected="a_id=5222640&p_id=2717&pc_id=6139&pl_id=39604"
    if echo "$runteq_url" | grep -q "p_id=2717"; then
      echo "  ✅ RUNTEQ: URLパラメータ一致"
    else
      echo "  ❌ RUNTEQ: URLパラメータ不一致"
      echo "    検出: $runteq_url"
      echo "    期待: $expected"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # TechElite
  if grep -q "a_id=5222635" "$FILE"; then
    techelite_url=$(grep -oP 'a_id=5222635[^"]*' "$FILE" | head -1)
    expected="a_id=5222635&p_id=7000&pc_id=20016&pl_id=88469"
    if echo "$techelite_url" | grep -q "p_id=7000"; then
      echo "  ✅ TechElite: URLパラメータ一致"
    else
      echo "  ❌ TechElite: URLパラメータ不一致"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # DMM WEBCAMP
  if grep -q "a_id=5222639" "$FILE"; then
    dmm_url=$(grep -oP 'a_id=5222639[^"]*' "$FILE" | head -1)
    if echo "$dmm_url" | grep -q "pl_id=38643"; then
      echo "  ✅ DMM WEBCAMP: URLパラメータ一致"
    else
      echo "  ⚠️  DMM WEBCAMP: pl_idを確認（38643以外のpl_idが使われている可能性）"
    fi
  fi

  # デジタネ
  if grep -q "a_id=5223371" "$FILE"; then
    digitane_url=$(grep -oP 'a_id=5223371[^"]*' "$FILE" | head -1)
    if echo "$digitane_url" | grep -q "p_id=4975"; then
      echo "  ✅ デジタネ: URLパラメータ一致"
    else
      echo "  ❌ デジタネ: URLパラメータ不一致"
      ERRORS=$((ERRORS + 1))
    fi
  fi
fi

# a8チェック
if grep -q "px.a8.net" "$FILE"; then
  # Tech Kids School
  if grep -q "45G9TM" "$FILE"; then
    echo "  ✅ Tech Kids School: a8matパラメータ検出"
  fi
  # SiiD
  if grep -q "45DZU6" "$FILE"; then
    echo "  ✅ SiiD: a8matパラメータ検出"
  fi
fi

# 2. rel="nofollow"チェック
echo ""
echo "--- 2. rel属性チェック ---"

# アフィリリンクにrel="nofollow"があるか
affi_no_nofollow=$(grep -P 'af\.moshimo\.com|px\.a8\.net' "$FILE" | grep -v 'rel="nofollow"' | grep -v 'impression' | wc -l)
if [ "$affi_no_nofollow" -gt 0 ]; then
  echo "  ❌ アフィリリンクにrel=\"nofollow\"が欠けている箇所: ${affi_no_nofollow}件"
  grep -n -P 'af\.moshimo\.com|px\.a8\.net' "$FILE" | grep -v 'rel="nofollow"' | grep -v 'impression' | head -5
  ERRORS=$((ERRORS + affi_no_nofollow))
else
  echo "  ✅ アフィリリンクのrel=\"nofollow\": OK"
fi

# テックジムリンクにrel="nofollow"がないか
techgym_nofollow=$(grep -P 'techgym\.jp' "$FILE" | grep 'rel="nofollow"' | wc -l)
if [ "$techgym_nofollow" -gt 0 ]; then
  echo "  ❌ テックジムリンクにrel=\"nofollow\"が付いている: ${techgym_nofollow}件"
  grep -n 'techgym\.jp' "$FILE" | grep 'rel="nofollow"' | head -5
  ERRORS=$((ERRORS + techgym_nofollow))
else
  echo "  ✅ テックジムリンクのrel属性: OK（nofollowなし）"
fi

# 3. テックジム紹介セクション内にアフィリタグ混入チェック
echo ""
echo "--- 3. テックジム紹介セクション内アフィリタグ混入チェック ---"
# 簡易チェック：テックジムの見出し〜次の見出しの間にアフィリURLがないか
# （完全な精度は出ないが、簡易検出として機能する）
techgym_section=$(sed -n '/テックジム.*｜\|■テックジム/,/<h2\|<h3/p' "$FILE" 2>/dev/null)
if echo "$techgym_section" | grep -q "af.moshimo.com\|px.a8.net\|gokindler.com"; then
  echo "  ❌ テックジム紹介セクション内にアフィリタグが混入"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✅ テックジム紹介セクション: アフィリタグ混入なし"
fi

# 4. 画像IDチェック
echo ""
echo "--- 4. 画像IDチェック ---"
img_count=$(grep -oP 'wp-image-\d+' "$FILE" | sort -u | wc -l)
echo "  検出された画像ID: ${img_count}種類"
grep -oP 'wp-image-\d+' "$FILE" | sort -u | while read imgid; do
  echo "    $imgid"
done

# 5. GoogleパラメータチェックURL
echo ""
echo "--- 5. Googleパラメータチェック ---"
google_params=$(grep -cP 'gad_campaignid|gbraid|gclid' "$FILE" 2>/dev/null)
if [ "$google_params" -gt 0 ]; then
  echo "  ❌ GoogleパラメータがURL内に検出: ${google_params}件"
  grep -n -P 'gad_campaignid|gbraid|gclid' "$FILE" | head -5
  ERRORS=$((ERRORS + google_params))
else
  echo "  ✅ Googleパラメータ: なし"
fi

# 結果サマリ
echo ""
echo "=== 結果 ==="
if [ "$ERRORS" -eq 0 ]; then
  echo "✅ check-sources: PASS（エラー0件）"
else
  echo "❌ check-sources: FAIL（エラー${ERRORS}件）"
fi

exit $ERRORS
