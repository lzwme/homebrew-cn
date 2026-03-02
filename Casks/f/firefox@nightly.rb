cask "firefox@nightly" do
  version "150.0a1,2026-03-01-09-10-22"

  language "ca" do
    sha256 "a238bc07933884eb676f5407160cea6095bd793604c56a01e374c263b2b2fede"
    "ca"
  end
  language "cs" do
    sha256 "6b81198369c11df0b043c718f38ee42143dabbdd1ed18d427141c2471dccc18b"
    "cs"
  end
  language "de" do
    sha256 "004ea0762553d43e0dde707bef1c3b3c791ac546cfb854d7c2fa1f07160575f4"
    "de"
  end
  language "en-CA" do
    sha256 "a1c6bccd2abf9ce4f896ab56a02d6cbd8a3f4e940a9f64c614f4dec9a34bb6d4"
    "en-CA"
  end
  language "en-GB" do
    sha256 "4bc11118903808837274d6f8bdae96a9deee8c83f0ed52676916ac013e0db302"
    "en-GB"
  end
  language "en", default: true do
    sha256 "9518134e5e9c45f68b12ca9108eef7dc295b73a7ffa9ed12db9ce95f346811f6"
    "en-US"
  end
  language "es" do
    sha256 "00fa754dd64d8d175c9732299913825fd95aaab728b988a919bca5070e7c549d"
    "es-ES"
  end
  language "fr" do
    sha256 "1cfc699bd7065001064368c2d7d5fa11c88f26e8cafb2787ec8aa0555e6a1e01"
    "fr"
  end
  language "it" do
    sha256 "2adbc5ff50bd1fc994edb3d74f2f7da8f6bd48ce5c9d0398bf00fbe16fd6fa42"
    "it"
  end
  language "ja" do
    sha256 "e435a0d7069a96080af469173a4f948ad576e7a047058238913f4e4b74394c70"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "348f2ddc9ba8889a81ae539c69e5541e091e5e7550b401b9e47c6dd504909e5f"
    "ko"
  end
  language "nl" do
    sha256 "b6538c44a1cfea623dd7055ae243821a767da8c709146b4f2dec76ad7b77aafc"
    "nl"
  end
  language "pt-BR" do
    sha256 "f156a26d1f734cf6599393d9fb650c3af08762a36123f86a9a8d29ad6058b48d"
    "pt-BR"
  end
  language "ru" do
    sha256 "9ad4e9101b3c6a615e1b0ddf599477ed3a9d4e29bda0374146d5659f1c3fb5b9"
    "ru"
  end
  language "uk" do
    sha256 "b518adb2c12ac36e42b1b348b198843d6ea761ee1e4ee682cc355f01526b11d2"
    "uk"
  end
  language "zh-TW" do
    sha256 "e9356c421946cdfe6631f63fa3cd545c80d60f7988076f49f5fc2eaa0c14af65"
    "zh-TW"
  end
  language "zh" do
    sha256 "c058e8f423a375a5d7605f8fb1466952eb90904961d79b1fba1600a944b89414"
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