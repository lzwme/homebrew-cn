cask "firefox@beta" do
  version "151.0b5"

  language "cs" do
    sha256 "dadb47c59d6b74d524f205449ea66d8819bbe42c4a73800f3cf6ac7d3e0a63b9"
    "cs"
  end
  language "de" do
    sha256 "76f163627e967c9c457c4bae6d8cc16854b3f4ce454166cea1c34d9b23dda2aa"
    "de"
  end
  language "en-CA" do
    sha256 "b8acaf986d4ee69d0bc0eff73660d68d27fef57c455176ed62df0ea28f9a7677"
    "en-CA"
  end
  language "en-GB" do
    sha256 "5f320f3688571656afd52734d8cd21f6de2be8857c8697e6aff50ed121306de5"
    "en-GB"
  end
  language "en", default: true do
    sha256 "d170c957c996db77a9f6159a17084df7fd63272fee8df265efcfc02a2e49cab2"
    "en-US"
  end
  language "es-AR" do
    sha256 "27b1dade712cb8210248d8eea5bc0b02007741597758226bbcb70caaa02843ca"
    "es-AR"
  end
  language "es-CL" do
    sha256 "b002478aeaa8a5a35759d144de460887860d5b173d736e5d5b87937bfa5c54ed"
    "es-CL"
  end
  language "es-ES" do
    sha256 "0109dee9de01b4feb7d775726a99e73f9781988b49f2aec5707dd4f6f68aed38"
    "es-ES"
  end
  language "fi" do
    sha256 "67e430dc867f9ab672e1adbae377d494ea99415a15dd32791739422a916c30b8"
    "fi"
  end
  language "fr" do
    sha256 "c8eaa993542e65f259428ea6fb9aa068abb58cce11eccee2d580df08014f6d87"
    "fr"
  end
  language "gl" do
    sha256 "0904e869698032a92e9dbe104dd93547ab5df140f1058b11602d47b263c699b3"
    "gl"
  end
  language "in" do
    sha256 "1e30ba304c9e7b0bc391a2344dd1778bbdb31e5d1fcb1b28c3e821acdbe085ee"
    "hi-IN"
  end
  language "it" do
    sha256 "d7672b492a81787f93c01f42b30b46c6cd6af2754e6483a1e2b08da0deaa4512"
    "it"
  end
  language "ja" do
    sha256 "9220831d647866c8be4e149dc4f51d1f8da9e6e0cf9a13dbc027dafc4c258d76"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "bb033a21881b5c5b525d1ec50ef9bc8055224126f7bbc3474adfdd255c770172"
    "nl"
  end
  language "pl" do
    sha256 "7226464e168815e129b646b44cd579f3e37adaa1b366c9c9d54fb25ad24a6352"
    "pl"
  end
  language "pt-BR" do
    sha256 "633b92f1d73bbadf09eb643b21f355e92a58c690c6293cffd7abe3dc5478ddc6"
    "pt-BR"
  end
  language "pt" do
    sha256 "6cee2ea990d85481aba5a18eaba77133a910aec6f78760df759dd110d7b834bf"
    "pt-PT"
  end
  language "ru" do
    sha256 "a0e1cae75acbc3d2f887172a753bf5ba2eb7251f1f66e0844dbf9655d2061572"
    "ru"
  end
  language "uk" do
    sha256 "ce3463fb1da66be29dcdae3f6eca04317df13023f8bf57806b05f8d20da9af93"
    "uk"
  end
  language "zh-TW" do
    sha256 "327d8f4b18e2b3b047f332cdfe16eb7bde2fae30cf7a49ed13de8de701416e1b"
    "zh-TW"
  end
  language "zh" do
    sha256 "79f1576072352bcd1b69be9b84371a4b37e430b8e907db94e656ed30339aeee3"
    "zh-CN"
  end

  url "https://download-installer.cdn.mozilla.net/pub/firefox/releases/#{version}/mac/#{language}/Firefox%20#{version}.dmg",
      verified: "download-installer.cdn.mozilla.net/pub/firefox/releases/"
  name "Mozilla Firefox Beta"
  desc "Web browser"
  homepage "https://www.mozilla.org/firefox/channel/desktop/#beta"

  livecheck do
    url "https://product-details.mozilla.org/1.0/firefox_versions.json"
    strategy :json do |json|
      json["LATEST_FIREFOX_RELEASED_DEVEL_VERSION"]
    end
  end

  auto_updates true
  conflicts_with cask: [
    "firefox",
    "firefox@cn",
    "firefox@esr",
  ]
  depends_on :macos

  app "Firefox.app"

  zap trash: [
        "/Library/Logs/DiagnosticReports/firefox_*",
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.firefox.sfl*",
        "~/Library/Application Support/CrashReporter/firefox_*",
        "~/Library/Application Support/Firefox",
        "~/Library/Caches/Firefox",
        "~/Library/Caches/Mozilla/updates/Applications/Firefox",
        "~/Library/Caches/org.mozilla.crashreporter",
        "~/Library/Caches/org.mozilla.firefox",
        "~/Library/Preferences/org.mozilla.crashreporter.plist",
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