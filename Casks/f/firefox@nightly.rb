cask "firefox@nightly" do
  version "150.0a1,2026-02-25-09-48-43"

  language "ca" do
    sha256 "03ad969697345f3aabb0503e0ea50d77a918f95455691a1b1874cf5b7a71c47d"
    "ca"
  end
  language "cs" do
    sha256 "13cf21de27ac6b91d3535d256197b850f0a27be3f35359c52da10f6521bb1182"
    "cs"
  end
  language "de" do
    sha256 "c692c0b49dbb64bb5c572e07bae42df279413089ef13cb56c00e5c369535a084"
    "de"
  end
  language "en-CA" do
    sha256 "ae34de22753871e7471bcddf6cf87a92a6351ee204d7098c39d33948441701ab"
    "en-CA"
  end
  language "en-GB" do
    sha256 "d0573c1c503630962e56dd2f1b9a301ddb34c26aa95fce25e05c123feb49a1d8"
    "en-GB"
  end
  language "en", default: true do
    sha256 "19589ff4bd46d40cd653adaab19e55a60c9fceaa23ed9d5ebf6650db2c9d6f85"
    "en-US"
  end
  language "es" do
    sha256 "663552a413fb4e7d4622b085ea5dd28f88bc82c2d6015652844654034d0c2abe"
    "es-ES"
  end
  language "fr" do
    sha256 "bc2b385eac6a2a71284f0d8da9725a0eb70abb643c4d0ab46d51b1de18387f6a"
    "fr"
  end
  language "it" do
    sha256 "1a66245510c871c620b26a476f53e73fcac6b0fb795045d15913f1004dbbc1a5"
    "it"
  end
  language "ja" do
    sha256 "71c2f8ed1a99950d313fbbd6f08e06e223da91cca8b0d5b20552b34d574a3e4e"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "26d419e8aa77951bb2f6592b8bb0856f0b1639ecc60451e674ed44e545700116"
    "ko"
  end
  language "nl" do
    sha256 "5ef672f3f238668651cf83b50c320d1a32b31067bfb9027580c3151a4a191237"
    "nl"
  end
  language "pt-BR" do
    sha256 "903fb2d5a6e05f7f43f26cbbe8aebd328000b464c3f5182dcff47af430bcd45c"
    "pt-BR"
  end
  language "ru" do
    sha256 "7421ec63ae004ee49bc473596e574f2ee3693b87ed76c2f8c84b5e43c8e6a7d4"
    "ru"
  end
  language "uk" do
    sha256 "2a881d8d07103e54f78ae8a6fcad56f2c08f3acc6bc8221ce5ad28c749cf443b"
    "uk"
  end
  language "zh-TW" do
    sha256 "bec9e1a9a9f34475d3e044bfe6b93fe6a7c0e6954fc0d89b97f6d1051a21e8da"
    "zh-TW"
  end
  language "zh" do
    sha256 "ee9c4f4e51b905aa67a3b4fd1ee29233f7332e84a2aa59dce737469415f40189"
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