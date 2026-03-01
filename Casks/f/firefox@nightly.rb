cask "firefox@nightly" do
  version "150.0a1,2026-02-28-21-02-22"

  language "ca" do
    sha256 "628a38647013d19b164c2f837b7a67ba348ada9456e2b6cd56a984b06ba51b2a"
    "ca"
  end
  language "cs" do
    sha256 "5f246034d745c3e5dc2d86c12e825ebab8338819b4bc22f001993e04624d61e6"
    "cs"
  end
  language "de" do
    sha256 "2e1d4305f01c98268b066a240c662d085ee6f03a76ccb36bb1516803e34c9d6e"
    "de"
  end
  language "en-CA" do
    sha256 "922956397047e8f9e9305eae9ab3423c09d0985a1fc95b6e00ac15986e731971"
    "en-CA"
  end
  language "en-GB" do
    sha256 "8ecf693acfa4139997daa49c49572c78b7705eb8008fe4f975903a24c2d0e67a"
    "en-GB"
  end
  language "en", default: true do
    sha256 "8ddfee609a0daea70d2a1d7ea6e66ecf53b48329d4f5b9fb14ee4b9e7da389bc"
    "en-US"
  end
  language "es" do
    sha256 "81afaa2766c4eb9200c7e37f323cd4010a5f16357a7b4773b62919ca99266307"
    "es-ES"
  end
  language "fr" do
    sha256 "5cd3ce4f3ac04ea5435d6ab15f8d7f9cb75b92fb1ed5afc4b623783b1459b1a6"
    "fr"
  end
  language "it" do
    sha256 "aab1940d4613aedcb90533927265989783c09317420bfe9d886b0e6455a7e797"
    "it"
  end
  language "ja" do
    sha256 "053329382f1805551ee1b1ecb5c438facaeab61460fb9eb5438b1d98e522d6a5"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "101a6e3d906db91e343ca444190825f15b5794279854ce453311490402e04338"
    "ko"
  end
  language "nl" do
    sha256 "6b3ef4552d279e87849e9dbc1ad98ec9bd9014365c03d42df4003d26328c6965"
    "nl"
  end
  language "pt-BR" do
    sha256 "fcbf228e8783ff1deb6c1027dbacc91624e3ecea262e1d01c33c613f538baea1"
    "pt-BR"
  end
  language "ru" do
    sha256 "ac1be8258055ce19b86cd38188c1e972aa370c5f9f84ed4360e031a9de979685"
    "ru"
  end
  language "uk" do
    sha256 "7f952d32302d9be4070e17b5d47cbb8a3382b1a7696439da9c1b4bebc4d7d324"
    "uk"
  end
  language "zh-TW" do
    sha256 "6a2917f989de43355da3ec3a622ffed65e75ae3ad035c85b4fda0cd979e68675"
    "zh-TW"
  end
  language "zh" do
    sha256 "5deeb1186fea6adbb48e102ba1d435c5218d58e15c16837fc135a83a3fce2cfb"
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