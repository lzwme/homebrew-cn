cask "firefox@beta" do
  version "151.0b6"

  language "cs" do
    sha256 "9666994ef4d172d714bac1be195e13e106bb94ebaa5c3a7ba94c7d7e614fa766"
    "cs"
  end
  language "de" do
    sha256 "01f040e4f62c80d8c5c0807c9a3e5f0e9b33ee35ae79d17a16df02782764a74f"
    "de"
  end
  language "en-CA" do
    sha256 "91e625bcc43a64352d711010af9e734e870ff74020dfbafd0436438b345fe9de"
    "en-CA"
  end
  language "en-GB" do
    sha256 "285812a1bf04dea008b1501aabe1d8574074a0d8ff8b769af35a9b3123886303"
    "en-GB"
  end
  language "en", default: true do
    sha256 "a7b99b04daf8f07bb6b15aa51b55b5a49e94ad2424129e576e8f253f7e8e0c88"
    "en-US"
  end
  language "es-AR" do
    sha256 "fea812e5af0c3b2e28b264faa643f92adec3904ad4a6f78d558dd2ea977b7175"
    "es-AR"
  end
  language "es-CL" do
    sha256 "e0254b0cde83cd2794d46a53c61fb23b0421cb1a9c62079283017c6eeb6ed848"
    "es-CL"
  end
  language "es-ES" do
    sha256 "e84d63f7cc2331593959e20dd2b62399d282a2857e9e5f3b49f8769e9fa45fd8"
    "es-ES"
  end
  language "fi" do
    sha256 "16a980839b5331cb9bb8a80ae20d6cf8df3a87792ab513bd3e6ba0d3f5f7d917"
    "fi"
  end
  language "fr" do
    sha256 "2eb89ee34d673e589d18b1b425037fa5d8c6f74af25b883010df6d909669f7fe"
    "fr"
  end
  language "gl" do
    sha256 "cd0e1f65b253c72d96fb091c22890ccad32e3f9a74c1dcb8e14e4758f7642afd"
    "gl"
  end
  language "in" do
    sha256 "0040f77076b8f83f4f5acb356633f615262df5b2474e3873c389c02bc1595492"
    "hi-IN"
  end
  language "it" do
    sha256 "6ebbc8ba017c5b8d5a9a86d1c9776ee9f82fff16ebd1e182309ee4c41dd0854f"
    "it"
  end
  language "ja" do
    sha256 "e56943942dd775868a2e26ef92d5c2743f5c2c11f281bda37302f9196c70fa58"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "d1adbc87403762a94fc3cfdbdb887d96ab3fa8a3ae7039870b8d1e59644193e6"
    "nl"
  end
  language "pl" do
    sha256 "0a20506d0c232d15bbdd29ceb2c332c205d2a0eddd51b07e3ed05dfc9b17434e"
    "pl"
  end
  language "pt-BR" do
    sha256 "576635f4cd71ce02c7b9ddd62b0969e6d0d37b473a4df4a036625bdbd1e752e1"
    "pt-BR"
  end
  language "pt" do
    sha256 "8cee4c97257705ecf917756935dfb73e5f64ecf7151501f4cf5d1bc117e36430"
    "pt-PT"
  end
  language "ru" do
    sha256 "26de59334d9b8b53cb4466671cb45461a8086cefa53cdf473046c6dc39ffbf77"
    "ru"
  end
  language "uk" do
    sha256 "99c810aba22f2929ebfab2d3459eb53ade8ab835ce70cca62316ad7cce240370"
    "uk"
  end
  language "zh-TW" do
    sha256 "511ef530a21e6158fb747f00b259023bb43f4c37a3b1401f1451be0fc7d49734"
    "zh-TW"
  end
  language "zh" do
    sha256 "fc276f617c3659ff0a4b786132830c016d907c0c0ced6d912dd3dd01d104dea0"
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