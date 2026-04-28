cask "firefox@nightly" do
  version "152.0a1,2026-04-27-15-57-24"

  language "ca" do
    sha256 "5f968f096ac0fc25bbd6218347aea20adcb8177aac5d47c67e117acc337f14ce"
    "ca"
  end
  language "cs" do
    sha256 "e527ab7d7ffe9f40eb78fa1c6fd174af13072a33d245be435d99766f400ca25a"
    "cs"
  end
  language "de" do
    sha256 "42baef2b9cd65f59ffe19fc6d75f0ede9f0a0d01d9944dcdc6dcdfb22d951264"
    "de"
  end
  language "en-CA" do
    sha256 "0475357322d69a11a76dd894b11a7fdad9d9c9f038fbb9114b760d028b8d2c66"
    "en-CA"
  end
  language "en-GB" do
    sha256 "8189e47cbd9341f10052a0d8d295dfd4454c8c8515b6b20328c359ce5389c8cd"
    "en-GB"
  end
  language "en", default: true do
    sha256 "6ce165182e95268413c8eff5fdfe38b15de4f398b870c7f38f7323f38262ab4e"
    "en-US"
  end
  language "es" do
    sha256 "acdd578f2b0b58724f816d3290c362ed0c815a0db2c06bf67f32aecca7c0b089"
    "es-ES"
  end
  language "fr" do
    sha256 "d8fce253477b2fc8d10868e6f7a29f677bb478099b02145a878c23355c2c116f"
    "fr"
  end
  language "it" do
    sha256 "67f6fd13ea0ea19a23d806fc430a16389572d5d2abed5817321a735b1b336253"
    "it"
  end
  language "ja" do
    sha256 "2af5bfdde11557d476e6e158a68896a5e1e5d29d59d30bd8be687552c884c7a5"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "b254e870779bbbdab505537be255d504db65dea7e222b5ed09e4cd80c8eb59d2"
    "ko"
  end
  language "nl" do
    sha256 "ecea16a4d27d45fafb82f4529c01713b9142ab6de6fae462b79a887c3fa92eb0"
    "nl"
  end
  language "pt-BR" do
    sha256 "397376e7fb6f6ed84959f95992a574b4bcf64e3249223187ee0d6544350a488b"
    "pt-BR"
  end
  language "ru" do
    sha256 "257df8df2a9e5d2637e4fe1a82f236dc6c66da4cdb58b7e62233ea8af035088a"
    "ru"
  end
  language "uk" do
    sha256 "443e70800b7a23827f87a818057f183bedbcfcad74f6ad70479a0011e4f7b128"
    "uk"
  end
  language "zh-TW" do
    sha256 "76f372e2717be256395d1ccfde362b07d9ef0671621d202f9081128700837f38"
    "zh-TW"
  end
  language "zh" do
    sha256 "7547f14e55ab4b989c00e12cbb9a296522efa67990181ef4489a9afb5db49eec"
    "zh-CN"
  end

  url "https://ftp.mozilla.org/pub/firefox/nightly/#{version.csv.second.split("-").first}/#{version.csv.second.split("-").second}/#{version.csv.second}-mozilla-central#{"-l10n" if language != "en-US"}/firefox-#{version.csv.first}.#{language}.mac.dmg"
  name "Mozilla Firefox Nightly"
  desc "Web browser"
  homepage "https://www.mozilla.org/firefox/channel/desktop/#nightly"

  livecheck do
    url "https://product-details.mozilla.org/1.0/firefox_versions.json"
    regex(%r{/(\d+(?:[._-]\d+)+)[^/]*/firefox}i)
    strategy :json do |json, regex|
      version = json["FIREFOX_NIGHTLY"]
      next if version.blank?

      content = Homebrew::Livecheck::Strategy.page_content("https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-#{version}.en-US.mac.buildhub.json")
      next if content[:content].blank?

      build_json = Homebrew::Livecheck::Strategy::Json.parse_json(content[:content])
      build = build_json.dig("download", "url")&.[](regex, 1)
      next if build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true
  depends_on :macos

  app "Firefox Nightly.app"

  zap trash: [
        "/Library/Logs/DiagnosticReports/firefox_*",
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.firefox.sfl*",
        "~/Library/Application Support/CrashReporter/firefox_*",
        "~/Library/Application Support/Firefox",
        "~/Library/Caches/Firefox",
        "~/Library/Caches/Mozilla/updates/Applications/Firefox",
        "~/Library/Caches/org.mozilla.firefox",
        "~/Library/Preferences/org.mozilla.firefox.plist",
        "~/Library/Saved Application State/org.mozilla.firefox.savedState",
        "~/Library/WebKit/org.mozilla.firefox",
      ],
      rmdir: [
        "~/Library/Application Support/Mozilla", #  May also contain non-Firefox data
        "~/Library/Caches/Mozilla",
        "~/Library/Caches/Mozilla/updates",
        "~/Library/Caches/Mozilla/updates/Applications",
      ]
end