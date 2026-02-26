cask "firefox@beta" do
  version "149.0b1"

  language "cs" do
    sha256 "921bfbdafc765ef2ddaf553e5344e3a3ad219fdd03cbd68dce3ec0a7ac7c853f"
    "cs"
  end
  language "de" do
    sha256 "b67126989c9421713ad3a341558613f2e8cc6c91765ff714190703bfbf0de8e1"
    "de"
  end
  language "en-CA" do
    sha256 "a912eb8073a3f5051ecd9111e0ff63b17c0f6378c49dae521f114ef52f05a46a"
    "en-CA"
  end
  language "en-GB" do
    sha256 "2fa31eb7e35c12b6632369961e0c764d085e178480e3e1edfce593018f5e9fa1"
    "en-GB"
  end
  language "en", default: true do
    sha256 "3d1f4abb063b47b392af528cf7501132fc405e2a9f1eccab71913b0fdf3e538c"
    "en-US"
  end
  language "es-AR" do
    sha256 "849f07c246c67fb20b3fffbdc5fb8933d6980f4fc87a0c4ff3f572fcd1a5206c"
    "es-AR"
  end
  language "es-CL" do
    sha256 "391bf360eefe812317df8d50a46e0f525431d70bbca952b632f5f9b25b352716"
    "es-CL"
  end
  language "es-ES" do
    sha256 "aed2c192278295104b7ac61ee8a58565db12cdf1689ca8d3e81777cfded8db55"
    "es-ES"
  end
  language "fi" do
    sha256 "d1588120b5880671a39b9730493c85c7ef258680103cbd633d0276adcdad5f1a"
    "fi"
  end
  language "fr" do
    sha256 "ffa8c0b065d10a0769bc93b3a1f36a0e8e7002f1ce28b15d4b705a3ceeb51f42"
    "fr"
  end
  language "gl" do
    sha256 "bb4b6195a229e125da8b687d87163653228f11c5bbe1ddea1ccbadc65c239e55"
    "gl"
  end
  language "in" do
    sha256 "a95134c34724ca669a1c196a54111b02c6ec6c8f058ed87daecdbef8ee2feb56"
    "hi-IN"
  end
  language "it" do
    sha256 "49386b6996644b660fe6912e65bc1bf03a0aaa3bdea0e70938fa80141f6842eb"
    "it"
  end
  language "ja" do
    sha256 "1721faec8324c784627498765856bc10050d09498c442a72048825d199eab3d1"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "e357beca7533801b494229aa47286e92d69d34467f752dd760b961abcd76f136"
    "nl"
  end
  language "pl" do
    sha256 "1529d1531bd4ae6f550f70f4cf7ad22d541f6fc25239ab1bfde7f0543e29c180"
    "pl"
  end
  language "pt-BR" do
    sha256 "aaeeadeed94772555fcbec40cc32466fc4f1741e686a2d875192f23f7fde3ca6"
    "pt-BR"
  end
  language "pt" do
    sha256 "8a759613a0e3539082f3710ddf1c4d16beae66c40846fb6735cef6e6e0965ed0"
    "pt-PT"
  end
  language "ru" do
    sha256 "71ed20c6b62e1489ffa2bcbf9ba757a843f98d7835d62c275fc4b57f555b565a"
    "ru"
  end
  language "uk" do
    sha256 "b6d7450dfc24f021333211691e7de7386770ba6f6195c8ec7825ef0d9b144a1c"
    "uk"
  end
  language "zh-TW" do
    sha256 "617274912022a3f1c23eb1c9fc1dab3da2ba5b9b85dd37c7055f307c9e6f65bb"
    "zh-TW"
  end
  language "zh" do
    sha256 "0e0d09e69ae0426d2f3cbf6a7c3301bfc7616c41f21052d7d8bd82a77ddc4c21"
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