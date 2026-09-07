cask "firefox@nightly" do
  version "157.0a1,2026-09-06-20-37-23"

  language "ca" do
    sha256 "c1465476dcaab304c2dc2346adb0c83c01b611d2048602d9f3c4e71b452c4877"
    "ca"
  end
  language "cs" do
    sha256 "6b3a70035f83062c2194e54b9561866e5fa9928790183c632e5b39bfa4c88467"
    "cs"
  end
  language "de" do
    sha256 "21c9c0993fdf93013f0c2ceda89e23bf3658128db113ba0d61e1e39840bb195a"
    "de"
  end
  language "en-CA" do
    sha256 "6dabe13e0b4c8cee528dbfb08a8f93204f9287e82971e37bb6289f0e441d5a33"
    "en-CA"
  end
  language "en-GB" do
    sha256 "30fc13a3d9febad870261f88bd6aabec926f2b71972e9bfa876e7f93805ddc4d"
    "en-GB"
  end
  language "en", default: true do
    sha256 "88fc19781f2d1a47d0b1bb7c03b7dcb8f8ba6551d2b59146e4c9a1b9a98dbbe0"
    "en-US"
  end
  language "es" do
    sha256 "9e9347e286bb5f727f246c1da6735468ff3816c1833b152d8ef9155e7772a6eb"
    "es-ES"
  end
  language "fr" do
    sha256 "c3cc6eba3e365f5646251739d69bd54e45b28857df109b4883928969b8367bfe"
    "fr"
  end
  language "it" do
    sha256 "ecdfd55ac1d361579e60fa1fd88c07155c0bd9abd58fff93db2654a99401741b"
    "it"
  end
  language "ja" do
    sha256 "8b331673469dde6699565f67bc64855d075b61240a58553722747036d5f8a08b"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "0fbe5ab66e6a1aaf3e6ad2182930fc7c3ee2d52afc549145ccd49a497ca42477"
    "ko"
  end
  language "nl" do
    sha256 "479eafe318f135071e9c280589e9bcc5ec91a643dbf94e59294c6b759b406b87"
    "nl"
  end
  language "pt-BR" do
    sha256 "43a145f9930932c94546cbc801de59881e12019b8b9bd9c2757796db2d1ccaf6"
    "pt-BR"
  end
  language "ru" do
    sha256 "c150a1239fcce0ebdfc33980f989c96bfc4da48fdb45611986bc9b3c5d4cdeae"
    "ru"
  end
  language "uk" do
    sha256 "5ac91b4c3757436c05598939344e0a32b15e51fa7ed37d361d3ab0c154e27229"
    "uk"
  end
  language "zh-TW" do
    sha256 "8553ee474babdb60dcd8b332dcd476c0a8361fc1662ae3d6c6bc1e5d70fced85"
    "zh-TW"
  end
  language "zh" do
    sha256 "7ab889c559c15230e29b4834973c82c5b3312182399d6510d12f7dcc6a4f0a44"
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
        "~/Library/Preferences/org.mozilla.nightly.plist",
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