cask "firefox@nightly" do
  version "150.0a1,2026-02-26-09-24-47"

  language "ca" do
    sha256 "ca5f5a3d09d0b5e471743afa17b65b55b2836847e4250eb00fab3a8e52eeaaa6"
    "ca"
  end
  language "cs" do
    sha256 "38a228734b6d886c45e6830dea6574aa6d509c8f93de26103280039d1aa68772"
    "cs"
  end
  language "de" do
    sha256 "d31057798a02f9e3ce69cbe3f5a9c37d70bdd2c65b28cb22417f567c4d89b921"
    "de"
  end
  language "en-CA" do
    sha256 "b3082a7a4388e7bea0fca83cd0f4dc304f7e1627d3eeb7e99456b25b7facffd9"
    "en-CA"
  end
  language "en-GB" do
    sha256 "4cdc5c23f005d88b9e31abb75d3620f134a2406777fc70759be45a89c0133033"
    "en-GB"
  end
  language "en", default: true do
    sha256 "58c3a7e16e16b39eb60845ebdeee79714db4121d1597459183274ce8f1177fb8"
    "en-US"
  end
  language "es" do
    sha256 "174c47638164f791bb0decc490929c8506debb37c8f47600509c8a240699d292"
    "es-ES"
  end
  language "fr" do
    sha256 "5bcfc3e4f998704a2c759e2a566baa99455f076509edaa2a343b2797940e8055"
    "fr"
  end
  language "it" do
    sha256 "09d5a177f1614d45b144a48530369ea920a20892f194de870134f5063c62e9fd"
    "it"
  end
  language "ja" do
    sha256 "e62ad3247d250153fb803f98f35203fa52fdf81cffd52636c0cd0ca6045adba1"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "73445cad68f645bb4abbe9fe2f8f31333762b9198adf78dd6d8b66873ecd0e18"
    "ko"
  end
  language "nl" do
    sha256 "dd87f9e19b2d45f1a740e81d7358783f560dfc19e2c556964bfe0a27865f1fdc"
    "nl"
  end
  language "pt-BR" do
    sha256 "c39d921424fbdf5f81fec98020a591cafa65571772e184060c6e63dfa914143e"
    "pt-BR"
  end
  language "ru" do
    sha256 "cae4699732dd895838f213c58ea2ebb754e69c913bce09f811bae04e58bfe5b0"
    "ru"
  end
  language "uk" do
    sha256 "d0cf0f44f2a430f7ca87e8f5f334da91a5d6d85001dbbc51a124ea4a935e2c10"
    "uk"
  end
  language "zh-TW" do
    sha256 "adb5d55b971eeca76f53c4aec607476d603e747a80e5740f2bc5ba7e55806a1b"
    "zh-TW"
  end
  language "zh" do
    sha256 "0c55949bdb5c8871895c49599d1eda4855e98b56d47ff4a1ab982dfc503ebce8"
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