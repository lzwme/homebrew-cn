cask "firefox@developer-edition" do
  version "151.0b4"

  language "ca" do
    sha256 "1c7bf64dade1eb6b83f5dfb1798ca1c1e19a88a46ac4958a24691441afc2322b"
    "ca"
  end
  language "cs" do
    sha256 "b5e3d94b648f0ca40b80b4cb45e15336843a091b3ce0562439c76e952c3cffb8"
    "cs"
  end
  language "de" do
    sha256 "bfa068e257e8748bdc827747d8238581e7638097d2b5aa5633110e5a47f35951"
    "de"
  end
  language "en-CA" do
    sha256 "8ed6b29ae5eec900951867074fd5351a97822fb3ea129578a3b8a5a2d05d0e0e"
    "en-CA"
  end
  language "en-GB" do
    sha256 "2c018f0dd925bfb5560a35f87e83e1673d57e4a53333f5515e1ce515f2fde619"
    "en-GB"
  end
  language "en", default: true do
    sha256 "a0c5dc895e25f478990bafd5fc811b4299ed005d58411d1253c7dd1a4a47e6f5"
    "en-US"
  end
  language "es" do
    sha256 "bc1b53aa61c1cf4665c2ec69c33bcfaaa1ce112c4790f20f64fc04071623915c"
    "es-ES"
  end
  language "fr" do
    sha256 "094c20845101e4014b28baf0e5c240ea2e358b69355cc8fec7f8dc85e037a51a"
    "fr"
  end
  language "it" do
    sha256 "f8b6b104851638f3f75843e1f4aa47ddae58b0251867663246d03c59a5ca1fdd"
    "it"
  end
  language "ja" do
    sha256 "9de81857032852bdd997753adeaa336ad2e05a25b84e42856c0440919a14c7f4"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "889748c2022cb320069e1af04f9ec928b992eb4c9aa0bea50102a4a30800ed03"
    "ko"
  end
  language "nl" do
    sha256 "be26136584b9b43483b0b848d9c26c2966c3f703cd34a739d6bc9138c412e56f"
    "nl"
  end
  language "pt-BR" do
    sha256 "439ee0151ee596ee238fd0e4c4a9cfbd70fb5fac5da88b522278d226547f921e"
    "pt-BR"
  end
  language "ru" do
    sha256 "9ec132a10f135a00633efaff11e348cd78476d7e7ed0a06424bab0161e5bec17"
    "ru"
  end
  language "uk" do
    sha256 "12307e8bf8f99b61e667f0fe8614a34577e3c516831332a5699b6feec4c84552"
    "uk"
  end
  language "zh-TW" do
    sha256 "ff7a60b7e0b8a340cb6ae71e78280deade3f4601516e6586335ba453755d39eb"
    "zh-TW"
  end
  language "zh" do
    sha256 "22654ff160d11f3cabd6cc325ebe2848b349d8e32c0e7f225cfc65cb7dfe2dbc"
    "zh-CN"
  end

  url "https://download-installer.cdn.mozilla.net/pub/devedition/releases/#{version}/mac/#{language}/Firefox%20#{version}.dmg",
      verified: "download-installer.cdn.mozilla.net/pub/devedition/releases/"
  name "Mozilla Firefox Developer Edition"
  desc "Web browser"
  homepage "https://www.mozilla.org/firefox/developer/"

  livecheck do
    url "https://product-details.mozilla.org/1.0/firefox_versions.json"
    strategy :json do |json|
      json["FIREFOX_DEVEDITION"]
    end
  end

  auto_updates true
  depends_on :macos

  app "Firefox Developer Edition.app"

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