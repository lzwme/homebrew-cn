cask "firefox@developer-edition" do
  version "151.0b6"

  language "ca" do
    sha256 "631acff65b55fea5877509a93a9590f683f0162c932a86302dff49b7b83bb86f"
    "ca"
  end
  language "cs" do
    sha256 "3977cb78f74115d928337d4487d6cddf92acf46d9d098fb4f5091dc5aa9bf363"
    "cs"
  end
  language "de" do
    sha256 "b3bbb07cbd7a8b16640e07654136f7d90a80ada33260af4c7bd82da630367773"
    "de"
  end
  language "en-CA" do
    sha256 "ffcb7be6850d9937b8593262f1ffb291643ea214c44049cdcbeade91dd46d0cc"
    "en-CA"
  end
  language "en-GB" do
    sha256 "1086282bf7e522efe0d2d6e39579b29083a0db4fef417615a85737703cab95fd"
    "en-GB"
  end
  language "en", default: true do
    sha256 "c5f18c7564e689afa6f0b7a06c973cd5f6601c13bcf748eb312468826b79812e"
    "en-US"
  end
  language "es" do
    sha256 "7da1fd3353623f06161a33e48147127345a7f2a820c675dda9628e30dc6e8d65"
    "es-ES"
  end
  language "fr" do
    sha256 "e41fd2fd996c83ecbdb232e4c9f881001666725a9b0ad362d458ed5f14f7cb56"
    "fr"
  end
  language "it" do
    sha256 "7942b9b46905a3cee38718c5e6b9996c4d381af7789a3d21b3a32afb37a4e675"
    "it"
  end
  language "ja" do
    sha256 "adf674fcee4185c3bdbdaf2d88465ce2fd76f62bd769ecb37254d1ef527c6561"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "28644e0c5d637c6d978efd4bb077028075e0f4e550aeac2b26bfa3772680ad1a"
    "ko"
  end
  language "nl" do
    sha256 "3e33a8033702dc95ee9b35317475297fae7305e438529a7d5109dc452432370e"
    "nl"
  end
  language "pt-BR" do
    sha256 "93b76b0a5579a43fe686e74c5f815259b11fc4aff706ccf14631367bfe1a3f52"
    "pt-BR"
  end
  language "ru" do
    sha256 "f27e83f8b50d3dc8042d2647617a50c6bc633ae5c4028723d9afdf407d18bcc6"
    "ru"
  end
  language "uk" do
    sha256 "3b6e37ae632d7deab23821c2f31c7bfb0c61964ffd45ee24628bb272966842a7"
    "uk"
  end
  language "zh-TW" do
    sha256 "2f9deb5b115c2e4ecafdb4ad6df23a1db68902f7327e44fc01637a1e56ad594f"
    "zh-TW"
  end
  language "zh" do
    sha256 "f6a4000c0e44c3d40b9e17b8fa9f6ea33057722c70b7d2e6ec5c874028a6f5dd"
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