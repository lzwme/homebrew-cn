cask "firefox@nightly" do
  version "152.0a1,2026-04-28-09-42-04"

  language "ca" do
    sha256 "1a58bbdf8996542e960b16d1f73ce49a73de5d00702eb7ca28f03fea6e51f3fc"
    "ca"
  end
  language "cs" do
    sha256 "7239842226fc4ee8b7fb3e5cb19daf5db66155fedfd21635fee937e618d4d318"
    "cs"
  end
  language "de" do
    sha256 "c7957bc663622b77442f5fabbdead6c9eeda832de9bc0ae34308260b03498e73"
    "de"
  end
  language "en-CA" do
    sha256 "709173b17960327f3ed09e589c77cc143f74b9e34e8de185f1faabdd2f0c9779"
    "en-CA"
  end
  language "en-GB" do
    sha256 "338eaa8d8c131c83b8a44e1c236008730f4dd35beec46a267f34a98312dc4f50"
    "en-GB"
  end
  language "en", default: true do
    sha256 "bc3156f2c3bc633eda8618190c5df83fe293a96e3502335083ed88b0d43866c1"
    "en-US"
  end
  language "es" do
    sha256 "0c0e9acb6bc0134ac5bb0d780754ca34410dce0e906307c6391a088ce7c3d11c"
    "es-ES"
  end
  language "fr" do
    sha256 "c9110bd510d080ce663206e6b60369dbf031c0faa5dd9340aeaa4ec2a76a9104"
    "fr"
  end
  language "it" do
    sha256 "a726ea898d4b9c12551cad7a8ae7759371e4f31faca1b304f3ad7a57407f28ca"
    "it"
  end
  language "ja" do
    sha256 "88bd85b5e9fedb7c81048c651ee6c3d172a381fdd77cc90d169a0ea4de57a6c3"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "7e737ed831573c8bc44e63e6c3121e62c7be43c5e86ae09436ab7eb9cbf33085"
    "ko"
  end
  language "nl" do
    sha256 "2c83e514cf5f6895ca66ac33bad4404158123edd8409c11ac6e4da2bb67da999"
    "nl"
  end
  language "pt-BR" do
    sha256 "944b7c2fe1882cf527f8028538da7711f3b49af1bb05fabcb0e5552faec2306d"
    "pt-BR"
  end
  language "ru" do
    sha256 "08e31ca4edd2f5bb629296b68f0abb742aba79495aa8ed4b34b99e519ef162e6"
    "ru"
  end
  language "uk" do
    sha256 "9633b9a637865eac39ec680c1808ad61a7966192a8ffbdb2844695ce2c0926f3"
    "uk"
  end
  language "zh-TW" do
    sha256 "f52c1b1d3c94e52bcd2dd941aab706aa9bd4992ef765aa5fa944208824aae6f4"
    "zh-TW"
  end
  language "zh" do
    sha256 "28526d0161927504a68ea64864ec4bcfbbeb2143c74febdd0a0897374d480a86"
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