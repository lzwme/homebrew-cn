cask "firefox@nightly" do
  version "150.0a1,2026-02-27-21-30-30"

  language "ca" do
    sha256 "91c8e711ee4336bd8786eaccc601c89d66671473db95170a34bdb458900334c1"
    "ca"
  end
  language "cs" do
    sha256 "057d14721ab7cf6e3bc9a8483e6bee80f3ac1997d2537d62e48bc2ae6cc2f825"
    "cs"
  end
  language "de" do
    sha256 "dbb68fbbdd72b93e6b336137d0da4d6cea31303355a611911f1563d02e4d71e4"
    "de"
  end
  language "en-CA" do
    sha256 "838662501e6570880ecc65351d432bd42b2572edf9ad43f335d7b288cb6d860c"
    "en-CA"
  end
  language "en-GB" do
    sha256 "a868ce6309d3b93f15fdd9e12b8c7a0d1e69b6b038b5c4da1b2d0821772afd19"
    "en-GB"
  end
  language "en", default: true do
    sha256 "9247e2bde62d4ddd1682a41bd13e38ba4cbe17d93f7853baf0adbd1498c10f5d"
    "en-US"
  end
  language "es" do
    sha256 "79047314c6f7798cf2b26ae7f004652f611271e0f1b83490544b0746d2a5b0ee"
    "es-ES"
  end
  language "fr" do
    sha256 "ca87e9e76a4d5e02ba0742e773d563cc024816e7725da123db7b896e22d2b8e8"
    "fr"
  end
  language "it" do
    sha256 "18f9619c8e04996b27cd728230231d566040e0846f650692c12eef54d66a0a6c"
    "it"
  end
  language "ja" do
    sha256 "7f8ca153f973e6cf7964c28c8fcff6329ecd28de24f3c0276507923d77b63af3"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "2f48de99f599a18e96e88d964f93c8eda20ff1426e1108e33e1e840680a219a5"
    "ko"
  end
  language "nl" do
    sha256 "0c181753646873a36f2363d7876a61366cb4a2a1c9dc70a5a355b4e7a87bd3e7"
    "nl"
  end
  language "pt-BR" do
    sha256 "27cde6bb1674bdb1de0463983760a3cec1c06cad9607b7ca96abdb23fd503e12"
    "pt-BR"
  end
  language "ru" do
    sha256 "0939ee1d671820755286dc663f2f623e2c4a07357364380127c2a4b34de503a3"
    "ru"
  end
  language "uk" do
    sha256 "d96b6987b3d109aa563fdbad163c429b1e90cc503b6e4ba6996d44d1005ba9a4"
    "uk"
  end
  language "zh-TW" do
    sha256 "53bc159c8f00e82bab213a5b91f76fef2b47170a0d452f2e23bcce9547e4568d"
    "zh-TW"
  end
  language "zh" do
    sha256 "ee8dc2af6915aba86ed0f225116bbb3a9567a885e8dced80c30f70d2d27ad244"
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