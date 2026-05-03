cask "firefox@nightly" do
  version "152.0a1,2026-05-02-21-37-01"

  language "ca" do
    sha256 "dd4cee13dfe1fb9dd6312d3d7bed9f01f0dd8e13f9dab4856b670f2483a131b0"
    "ca"
  end
  language "cs" do
    sha256 "fdbd02e9108bf9e83fbc463bf25e92d38e008427027b7bb934e4cad0ba761844"
    "cs"
  end
  language "de" do
    sha256 "907d3f77ae23c4027489bf169c96ad5e5f1d6903d68739f46166c32c64760805"
    "de"
  end
  language "en-CA" do
    sha256 "56efdb630d68bfe1a4977a61284d4d5b313678f4cffb200f5b2dec76d0af0b28"
    "en-CA"
  end
  language "en-GB" do
    sha256 "d133e69e4b1caa6a5568ac27deeeee4f1fd720a01461f77b0838e13cb080b0e0"
    "en-GB"
  end
  language "en", default: true do
    sha256 "add032cc58290db1c2f56e39b0b1885a71016676662c10f616dadaa49ac5125c"
    "en-US"
  end
  language "es" do
    sha256 "3d53d41b6e79137c81ac6d2bd8ff9acd64231a2b3b1b1f0ec6b829d1494a3e05"
    "es-ES"
  end
  language "fr" do
    sha256 "a85d886d2d26b1f9be3b08feb26554f87a32f9e0d55944cff83915a1e439212d"
    "fr"
  end
  language "it" do
    sha256 "6968e9362aeb1332555c14ca5c4dfc55d39d0c576e0ca119998b06132fdf60b6"
    "it"
  end
  language "ja" do
    sha256 "8b49972fa8a83ca1165ca9df5bf92d98ddde6a3dfcd40ca52c13126ccb0c77e7"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "b5a9920a1f78af416bc4100e6f8dc698fccde67a7642eced556b899dffaceb65"
    "ko"
  end
  language "nl" do
    sha256 "d01120428db3fc1dc913ea28d27d2a23b6a9ab760f3c9e7a8dc30ca246e0ffbf"
    "nl"
  end
  language "pt-BR" do
    sha256 "77ccf42413e076e6376e4f00536894adfd59c9cc4e2e9e05f84744b460dc8672"
    "pt-BR"
  end
  language "ru" do
    sha256 "4dae00f6ab2bf69adaade17d850159ff75980a9d96ddba0a123e22b7a31d7f1c"
    "ru"
  end
  language "uk" do
    sha256 "6beb1a71e26f2de9ba5f1bd16513b2b6b9ac81b58df38eda06fd0db587c6a648"
    "uk"
  end
  language "zh-TW" do
    sha256 "a90c04a58ed6d5840f66531ba64c037341d17c10eeea11a54b71c7f6a6a3aa6c"
    "zh-TW"
  end
  language "zh" do
    sha256 "f541fa284f6502c5f87cddebe6be5879ac344fc0bd23e49d6d10b54c073ba43b"
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