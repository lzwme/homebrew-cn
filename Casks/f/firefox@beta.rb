cask "firefox@beta" do
  version "151.0b4"

  language "cs" do
    sha256 "1b3c8a5c4444eb0d29ce348802f15b7e8b1aeffadc0ad173404f95cb7c2961c1"
    "cs"
  end
  language "de" do
    sha256 "9f9976ec0f37364f66c82f42232fab96ade7136779b9d836ded6946becf48988"
    "de"
  end
  language "en-CA" do
    sha256 "a3c3763cd1326ecbfb396fbce8eb31f6a202e11339e68b10a15c2540811c6dcd"
    "en-CA"
  end
  language "en-GB" do
    sha256 "435ccea1536bc0a67d6712de9c99df9fca886aabd0ef4ca1d96144cf8aeca9ad"
    "en-GB"
  end
  language "en", default: true do
    sha256 "2691da587daeae2da5cfa2f3a95271ffb17bc4e363d2a1cc43d1bd09926a99a8"
    "en-US"
  end
  language "es-AR" do
    sha256 "4e46e5c73049153dda8368a5cb6f4617f79193bc76a40e6099baac826525b9bb"
    "es-AR"
  end
  language "es-CL" do
    sha256 "47435b2bf4b562254f3ee86cdc3f561b162cd885f659a37a468da865450c5403"
    "es-CL"
  end
  language "es-ES" do
    sha256 "e7bfda67dff2f720fc00da264fd02c5c285a134d21132afeb779dd02a197f27a"
    "es-ES"
  end
  language "fi" do
    sha256 "920a8e5e7328c02da69a7f1207259dc9d43b2d8a103a8ef01bbbbb5fce350010"
    "fi"
  end
  language "fr" do
    sha256 "dfa646d23403c047aae4beebf74834b38eed7991e8d26b3bff9acf1c9f955f08"
    "fr"
  end
  language "gl" do
    sha256 "bfbdb5feeca0e87f373f1c56a4c88e045db079285931700c6beaa29b65414f00"
    "gl"
  end
  language "in" do
    sha256 "820c0a5cf412909d765874a60d18988ef173dee4b3b5d9ff0217ca02bd972093"
    "hi-IN"
  end
  language "it" do
    sha256 "cac3b8b6c8d9cb369be5716a967b8753bae9d13cc2806335d142e58a7b65a24d"
    "it"
  end
  language "ja" do
    sha256 "ce3f1b69e049c831a2d78b1f8ab8b09230491c391a20d2de8b8c0fd7319d7d5d"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "9b608542515566b0dbf25ae9db427be004173d5b43022baf3f2bbbd83f28c316"
    "nl"
  end
  language "pl" do
    sha256 "015bd66d44422dde296b9ab026accb904380af63c842c150ec59ab8806c76f42"
    "pl"
  end
  language "pt-BR" do
    sha256 "bdc93314a9f19c0ae577356d159b80d444cb78e8820ddf21266f02d2bf790ef6"
    "pt-BR"
  end
  language "pt" do
    sha256 "270ee702d2d5ed3cf47c09b6e151f455dea5f42f8c9642b51c7dad67582ac963"
    "pt-PT"
  end
  language "ru" do
    sha256 "d8fb334853310fa5e230a29060301221e0efb857803f54bdb1f1244ba4b2bf23"
    "ru"
  end
  language "uk" do
    sha256 "1a5d7f8de237556a43d8b41210ecca6910384fc49e56a17c6f4d73ecd036b250"
    "uk"
  end
  language "zh-TW" do
    sha256 "5adf4f4a51c2900ca69b755a215c926e6a6e38fcf4d6746cfd6b4c5c0fa0e7b3"
    "zh-TW"
  end
  language "zh" do
    sha256 "ed584efc69804cda30090563244b9258e5279c1286f55a55a8e1b82353bbbf66"
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