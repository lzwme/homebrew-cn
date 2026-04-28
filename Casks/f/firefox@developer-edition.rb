cask "firefox@developer-edition" do
  version "151.0b3"

  language "ca" do
    sha256 "9de9d6e8bd276b41fae83293ee0fd3aec9661fb35e273c88edcd6b460cb62471"
    "ca"
  end
  language "cs" do
    sha256 "3889a4e2999f86c33743640352feae14a0836893083b916b2bd993cbce0d945c"
    "cs"
  end
  language "de" do
    sha256 "5ed7c2dd6ecee14b7a7ed4d7e73fb423a2cc90cd50bba0c4ec871d2c50b61fbe"
    "de"
  end
  language "en-CA" do
    sha256 "3dc005c403b8771d585a1907cd22cbac583f767d40130a15261ddcd4cdfb2f9f"
    "en-CA"
  end
  language "en-GB" do
    sha256 "8dd9dfdbec65f9be3016e8e1a1d6044aa0b5330e030db88089f7855ec5b7b958"
    "en-GB"
  end
  language "en", default: true do
    sha256 "4976bb795b0797c733348bb3a5ce0b20d27d352880493d392961534d0ee5edc2"
    "en-US"
  end
  language "es" do
    sha256 "4c4265cea84a13349c3c34a83babd7262e3d7f3cc7330a43719373e33ec8babf"
    "es-ES"
  end
  language "fr" do
    sha256 "77e93c09baf624d42d2532258735d6f08840334925ce0de70fdf0c159dad8c9e"
    "fr"
  end
  language "it" do
    sha256 "a29b5f4e8a40f1a70911543f6d61db394c1d3346d81603776da775a0964b1a05"
    "it"
  end
  language "ja" do
    sha256 "77820e71921f533188a0b396982dc0cb5a20d825a9013bcbd668acc69de13170"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "25fba77dc6c2b806e14fd3d18fcb13ee31b407091ad72aadeb0aa24c9bb22c65"
    "ko"
  end
  language "nl" do
    sha256 "233bcb7c690ca02dbaf09cf4301ba197b4dac15a7fa56594ba9dffc6583c00cd"
    "nl"
  end
  language "pt-BR" do
    sha256 "8fc31a5d70483f3fb7c99e4ec10e4a04760d7b2611564c78dc548e3b30a70c68"
    "pt-BR"
  end
  language "ru" do
    sha256 "633e8957537eb1113d1c67bff8f9358b191df02631c03bcb83bdd4cb64982eed"
    "ru"
  end
  language "uk" do
    sha256 "a7a24fca5970affdc634d5aeb8b23b8d3f95729b6f98c9bb86702f1159823499"
    "uk"
  end
  language "zh-TW" do
    sha256 "8fc384b6b3c0442d4d1711e47bd25e6e5acd349d7baefec27e7fb5397888fdaf"
    "zh-TW"
  end
  language "zh" do
    sha256 "a58d21e60f58c428b758b0fdb2514252690585e1f6dbd1947f0c73f8efb4dc68"
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