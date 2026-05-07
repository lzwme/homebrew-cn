cask "firefox@beta" do
  version "151.0b7"

  language "cs" do
    sha256 "f36032f1851f93c2646bdc5688104c9cc2ce1410e0a07e7c3dad4c50573c87df"
    "cs"
  end
  language "de" do
    sha256 "9aae6795a33b877a3c5fdeb454f8c7b9e7c51529d71f4bc7503cccf68d5bdf3b"
    "de"
  end
  language "en-CA" do
    sha256 "97750b4bf1a4a594070317283f3c845b37a40292bedfe084dd9b035f44cc4f4a"
    "en-CA"
  end
  language "en-GB" do
    sha256 "72b610d03c44ec1a8e26ad0c4036a159b538e792026d9a97845cff6967e9115a"
    "en-GB"
  end
  language "en", default: true do
    sha256 "6f79d038ae5a8872c5f9280497a4ca27a17a3cde4a80a2b8d401a166b8a069ac"
    "en-US"
  end
  language "es-AR" do
    sha256 "025b2a2a911d5940b6b3852be3eabdef685a0bd2117e262e6710fa5a1627b700"
    "es-AR"
  end
  language "es-CL" do
    sha256 "01a7d1f798b61bf1679f3d1e18d2145be101bc2e2b2cabb2d60f385c210f058f"
    "es-CL"
  end
  language "es-ES" do
    sha256 "8ad5a209bc9d001a9932261b0080aff5a12ab26908b53ea2e681f2d989fbfba0"
    "es-ES"
  end
  language "fi" do
    sha256 "26ff2d398760c60d938588870f956240a9cba7c53ef987a932eb9d1c1d568d44"
    "fi"
  end
  language "fr" do
    sha256 "2dbc86b012679959f5ac69a79d79ab076a7a9db66977153fb37911a518b820d9"
    "fr"
  end
  language "gl" do
    sha256 "c13bfb030dd345f9416ac1682bbb2a11ea0f1d4f3b22c05caa9897484596cff7"
    "gl"
  end
  language "in" do
    sha256 "364a327f0e9b8d75290f64a5b0c95a668217b4f6333a4f5330da815d38e8a498"
    "hi-IN"
  end
  language "it" do
    sha256 "d4985d4b043ee79493a30e38265eddcd09e9c165d2471a744ae0e1b4d1831ad1"
    "it"
  end
  language "ja" do
    sha256 "e58796a3417f864645ac862789efebcdc560b0b1f7b2a427f66b40faddf1b10d"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "847e10db689b3a4f73b0dd07b21c68cd34f8b8a873c9dd6180ca8a6b471b406b"
    "nl"
  end
  language "pl" do
    sha256 "cf6648fc92e4ebf574149bd34c2d6a1acd8ea6b110b341d7c9c99d015bafa7e2"
    "pl"
  end
  language "pt-BR" do
    sha256 "d6609d52acedd1b9a7d9e730f6b2605788644eac059779d9fed509d12e69ccc0"
    "pt-BR"
  end
  language "pt" do
    sha256 "130edabf994bda9d2ff1019f54fad7d5ab9418baf8a7fd9a75c2216d3ff42b13"
    "pt-PT"
  end
  language "ru" do
    sha256 "a943fb8e1b032fb295c21ebb5f912adf3ed203c6165a4d3f092780b7d271d6c4"
    "ru"
  end
  language "uk" do
    sha256 "2fbf6dc2cc413a5be849ebf1678ca87d3c788f5166460847f0f1dcace3d5d181"
    "uk"
  end
  language "zh-TW" do
    sha256 "9a424ec3fcc2223c4649b3be64bc985241a5a5273dcc167f552e407136bc5128"
    "zh-TW"
  end
  language "zh" do
    sha256 "c4752295a68d4a9ccc1ed01e2b0a3daf1440a9c4b0987fb2a3d65194704c70fb"
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