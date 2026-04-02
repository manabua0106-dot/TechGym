# TechGym CTAテンプレート一覧
# ヤマダイのshortcodes.mdに相当。TechGymにはショートコードが存在しないため、
# 全てのCTAは生のHTMLリンクまたはVKブロックスボタンで構成する。

## 1. 冒頭訴求テーブル用CTA（地域別比較記事）

### RUNTEQ
```html
<p class="btn_1 text-de-none"><span style="color: #ffffff"><a href="https://af.moshimo.com/af/c/click?a_id=5222640&amp;p_id=2717&amp;pc_id=6139&amp;pl_id=39604" rel="nofollow" style="color: #ffffff">詳細はこちら</a></span></p>
```

### TechElite
```html
<p class="btn_1 text-de-none"><a href="https://af.moshimo.com/af/c/click?a_id=5222635&amp;p_id=7000&amp;pc_id=20016&amp;pl_id=88469" rel="nofollow"><span style="color: #ffffff">詳細はこちら</span></a></p>
```

### Tech Kids School
```html
<p class="btn_1 text-de-none"><a href="https://px.a8.net/svt/ejp?a8mat=45G9TM+4MPL3U+4380+BWVTE" rel="nofollow"><span style="color: #ffffff">詳細はこちら</span></a></p>
```

### デジタネ
```html
<p class="btn_1 text-de-none"><a href="https://af.moshimo.com/af/c/click?a_id=5223371&amp;p_id=4975&amp;pc_id=13311&amp;pl_id=65313" rel="nofollow"><span style="color: #ffffff">詳細はこちら</span></a></p>
```

### DMM WEB CAMP
```html
<p class="btn_1 text-de-none"><a href="https://af.moshimo.com/af/c/click?a_id=5222639&amp;p_id=1000&amp;pc_id=1380&amp;pl_id=38643" rel="nofollow"><span style="color: #ffffff">詳細はこちら</span></a></p>
```

## 2. 本文中のアフィリCTA

### AI CAMP（gokindler経由）
```html
<a href="https://www.gokindler.com/aicamp-long1/ai-camp︎techgym/" target="_blank" rel="noopener">AI CAMP 公式サイト</a>
```

### RUNTEQ（本文中リンク）
```html
<a href="https://af.moshimo.com/af/c/click?a_id=5222640&amp;p_id=2717&amp;pc_id=6139&amp;pl_id=39604" rel="nofollow">RUNTEQ</a>
```

### TechElite（本文中リンク）
```html
<a href="https://af.moshimo.com/af/c/click?a_id=5222635&amp;p_id=7000&amp;pc_id=20016&amp;pl_id=88469" rel="nofollow">TechElite</a>
```

### DMM WEBCAMP（本文中リンク）
```html
<a href="https://af.moshimo.com/af/c/click?a_id=5222639&amp;p_id=1000&amp;pc_id=1380&amp;pl_id=38643" rel="nofollow">DMM WEBCAMP</a>
```

### SiiD（a8経由）
```html
<a href="https://px.a8.net/svt/ejp?a8mat=45DZU6+604DDE+5RIA+5YJRM" target="_blank" rel="noopener">SiiD</a>
```

### Tech Kids School（a8経由・本文中）
```html
<a href="https://px.a8.net/svt/ejp?a8mat=45G9TM+4MPL3U+4380+BWVTE" rel="nofollow">Tech Kids School</a>
```

## 3. テックジム自社CTA

### AI駆動開発コース
```html
<a href="https://techgym.jp/about/ai-driven-development/" target="_blank" rel="noopener">テックジム AI駆動開発コース</a>
```

### テックジム東京本校
```html
<a href="https://techgym.jp/tokyo/tokyo_honko/" target="_blank" rel="noopener">テックジム東京本校</a>
```

### カウンセリング予約VKボタン（東京記事用・光るエフェクト）
```html
<!-- wp:vk-blocks/button -->
<div class="wp-block-vk-blocks-button vk_button vk_button-color-custom vk_button-align-center is-style-shine">
  <a href="https://select-type.com/rsv/?id=1uN3_eag4IU" class="vk_button_link btn has-background has-vk-color-primary-background-color btn-md" role="button" target="_blank" rel="noopener">
    <div class="vk_button_link_caption">
      <span class="vk_button_link_txt"><strong>カウンセリングの予約はこちらから！</strong></span>
    </div>
  </a>
</div>
<!-- /wp:vk-blocks/button -->
```

## 4. 非アフィリ他社CTA（汎用テンプレート）

### VKボタン形式
```html
<!-- wp:vk-blocks/button -->
<div class="wp-block-vk-blocks-button vk_button vk_button-color-custom vk_button-align-center">
  <a href="[公式サイトURL]" class="vk_button_link btn has-background has-vk-color-primary-background-color btn-md" role="button" target="_blank" rel="noopener">
    <div class="vk_button_link_caption">
      <span class="vk_button_link_txt">[サービス名]の詳細はこちら！</span>
    </div>
  </a>
</div>
<!-- /wp:vk-blocks/button -->
```

### テキストリンク形式
```html
<a href="[公式サイトURL]" target="_blank" rel="noopener nofollow">[サービス名] 公式サイト</a>
```

## 5. もしもインプレッションタグ

冒頭訴求テーブル内に配置する1×1ピクセルの計測用画像：
```html
<img src="//i.moshimo.com/af/i/impression?a_id=5222639&amp;p_id=1000&amp;pc_id=1380&amp;pl_id=76523" width="1" height="1" style="border: none" loading="lazy" />
```

## CTA配置ルール
- CTAはサービス紹介文の最終行に配置する
- テーブルや紹介本文の途中には入れない
- 1サービスにつきCTAは1つのみ
- URLにGoogleパラメータ（?gad_campaignid=、&gbraid=等）を付けない
- アフィリサービスには必ずrel="nofollow"を付与する
- テックジムにはrel="nofollow"を付けない
