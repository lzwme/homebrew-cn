cask "firefox@nightly" do
  version "152.0a1,2026-05-06-21-07-44"

  language "ca" do
    sha256 "a35d89e25767b66af87ed91531a5bd2b0d1bce93c059f802235ba6b21ce63b3d"
    "ca"
  end
  language "cs" do
    sha256 "4a32bf5f68bf604843abc5ab5940ebe6389991bd967caa7d93fa95662e656dbc"
    "cs"
  end
  language "de" do
    sha256 "630001d7a99fd1210630e14c335ff5e42687321a93f47b7fd1252e31ba57cd4e"
    "de"
  end
  language "en-CA" do
    sha256 "9139458d0deda800cbaa56233c2696cebe344d95fe7c7e0fe2096cc0dad4c69a"
    "en-CA"
  end
  language "en-GB" do
    sha256 "1b42c61a77075ae17ccfa0f31c3c4bfbdb0839fdee072b140a5f7b573d5fe1ff"
    "en-GB"
  end
  language "en", default: true do
    sha256 "3f28042a308aef9328613fc2b0ebe4275eb83a6962c3e93a7409f73e5f4fcfda"
    "en-US"
  end
  language "es" do
    sha256 "0f417605a5174aeb3a245603b041071edff429fb4e1dc564e56bc373bfb714e7"
    "es-ES"
  end
  language "fr" do
    sha256 "b5a34b6bcb22da54884067d771683cbea52d57a9499fe8b0d87fb61849900225"
    "fr"
  end
  language "it" do
    sha256 "3f7610ee1acdb42e35389cadcccaa8a0d136058bb56e58980215c303a3c7b698"
    "it"
  end
  language "ja" do
    sha256 "28124c2c9b50d971bb0051cf44ab12621511bc8aed3a8785e6b18eee5aaeee5d"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "59f6cd9d81a3a6b5cbfcd02d0cd3e92319748c89ee9dae68b6863f7e7c057b37"
    "ko"
  end
  language "nl" do
    sha256 "6a72fde0b411580445365b286bba9679ec392ff90d522fc81909c6512f1e06ae"
    "nl"
  end
  language "pt-BR" do
    sha256 "a93b556324d48b684f8f3e7e5e1fb6582f4432170d0dd867a44a7b22c994c0f4"
    "pt-BR"
  end
  language "ru" do
    sha256 "f6a2bb67ab0c51e79a6fa233a7ddb486617e7cf30fae47fe6b50560bdf535d3c"
    "ru"
  end
  language "uk" do
    sha256 "678c41845496e778f1b729250996daabf3ff52b19065b39038fb7c1a31d0e602"
    "uk"
  end
  language "zh-TW" do
    sha256 "6a498a242196855615105fd66ea35fda4dba232e70b29ad79ea8965f33f06ac2"
    "zh-TW"
  end
  language "zh" do
    sha256 "4090df18bd19ab415a633b81d94f7265593322810658b50822077bba590c26f0"
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