cask "firefox@nightly" do
  version "150.0a1,2026-02-24-09-50-58"

  language "ca" do
    sha256 "a0a518a22af530519ea45be5d0a23487fea51848dc4f40d194097e7cd9899c64"
    "ca"
  end
  language "cs" do
    sha256 "08159bdaaae154536d07bb01343da19786d32cdce21aa5a430d3cdb4ebccb3bc"
    "cs"
  end
  language "de" do
    sha256 "adb339830d191bc03ece9117d0db8885fc1eb9ad591a8c71e40c7c0e6bc326dc"
    "de"
  end
  language "en-CA" do
    sha256 "1d3de6d252bf2afd1c7bf325d19a328320effe3699fd621916d5abfb4f8b2998"
    "en-CA"
  end
  language "en-GB" do
    sha256 "0795b25131cbb88a43b29312bd841b77b41a43406c3be27734be57baad087ed5"
    "en-GB"
  end
  language "en", default: true do
    sha256 "f67b95fd07cb920525d9e64234753cdfbee00971f1a861644d0646eb02be07c5"
    "en-US"
  end
  language "es" do
    sha256 "5539f6244c06ffeadcca5cdf9c5023a74b3ce1756ab83d7e2b02b052b8517b18"
    "es-ES"
  end
  language "fr" do
    sha256 "08c62fb8314c62e5aefad108b14547c3fcd09568578b7f7c1ee41aff89a5d645"
    "fr"
  end
  language "it" do
    sha256 "a510e5a7f2db00f2d1b0bd10741b950bb9e5618e8c2987d34c347ebb20011025"
    "it"
  end
  language "ja" do
    sha256 "e52837a95344212672b8cdf9b34006f5abe0c8093751a039ad333c3ff6054922"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "55e0117babc760539d9c8271fe70721d8c84d7807c07c0686f1ba155e514d46b"
    "ko"
  end
  language "nl" do
    sha256 "bd0b9dcff58e407dee81e7d65f0ea4128ffd04ea5560d6390dbcf30d7a3feffd"
    "nl"
  end
  language "pt-BR" do
    sha256 "83d3a412635fad76c0c2d9012227b2c3d53b731f1fb0f5cecc5c5ccc1f1c1dc2"
    "pt-BR"
  end
  language "ru" do
    sha256 "fa5a2e595d5128ce6d6edc4b3e7a297d6ce305fe9874cf504d4f49b0dc7ba889"
    "ru"
  end
  language "uk" do
    sha256 "be6bcaaae658ef685316699031e4f1da234f2d5f9ff7ed19a0765fa95f201747"
    "uk"
  end
  language "zh-TW" do
    sha256 "ff4833f518cc7c22081e217d37e3edefcef85c3223b0d1568619034b0e044e43"
    "zh-TW"
  end
  language "zh" do
    sha256 "0439263fb216371bec5014c2ae42a8847256cc6cdc407e04426dd5b58fe9f55d"
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