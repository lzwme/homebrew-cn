cask "firefox@nightly" do
  version "152.0a1,2026-04-29-20-34-45"

  language "ca" do
    sha256 "30eaff05542002859276661b63fe9c62464825c58298b5f0a7bd7a0a6c58de57"
    "ca"
  end
  language "cs" do
    sha256 "3aec4f7bba2dfc0528e25e361a6bf6e62507c965eeb8131d1d4d8515ecbc0e96"
    "cs"
  end
  language "de" do
    sha256 "bd04784a450459c506f03dcffd485a6791a6b9492ea929017a809f92ce8f01af"
    "de"
  end
  language "en-CA" do
    sha256 "2c3c5a34a70619bc4251c7445d235010422a7def748cae1f3eb614fe61bb6891"
    "en-CA"
  end
  language "en-GB" do
    sha256 "b7099518423354323957ba60c2884d84bf1c24277fd5eec44b8a4d2c354abdf7"
    "en-GB"
  end
  language "en", default: true do
    sha256 "20111c8e8edf8bcbaf02775ecdf56e18e3edef0f0c415a5504cc90082801b9ae"
    "en-US"
  end
  language "es" do
    sha256 "188dfd35b777432310d67a901c427e85b884f21bb6679633f2e0f9ef8cd1af60"
    "es-ES"
  end
  language "fr" do
    sha256 "b17f3b8f1830a7468914ada3bfe22c913eea8d560334132ecf8c520f5be74cfd"
    "fr"
  end
  language "it" do
    sha256 "737217271a3d8fb8ecead971a427cabc5585cf17cc88d67a909f6cb1661321b5"
    "it"
  end
  language "ja" do
    sha256 "a56496ec553369ef7977306ff9729c60507af8fad2f7f5001e1acd1b63d38aa6"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "ba674be3205024db297ac6d33c603a081c2497bec557d686b06b2c23de621c9c"
    "ko"
  end
  language "nl" do
    sha256 "0fb3985a999559486d41804528bc9f7456225582c7955dffc9a0f9b43423db9a"
    "nl"
  end
  language "pt-BR" do
    sha256 "0ce44be3629a2bff1229bb48179a8c19b64cecffbda41878b72faa703a683085"
    "pt-BR"
  end
  language "ru" do
    sha256 "e5187ca744d79a3bcfdcc629f49905a0de6d5858120862314c1487d688e83016"
    "ru"
  end
  language "uk" do
    sha256 "d85d4104eaabbb3ea769cc9d93ef7955145252fd9829e541afb1b9901e5918ce"
    "uk"
  end
  language "zh-TW" do
    sha256 "41d9a8d31d2612cf2c44c1a01001409c3b6e578a4151983f11e607bfe29e48c3"
    "zh-TW"
  end
  language "zh" do
    sha256 "a520ee3a6debbbe933762d7bb11984d3bd0e930acd0e3377fdfc889696ababd0"
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