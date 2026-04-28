cask "firefox@beta" do
  version "151.0b3"

  language "cs" do
    sha256 "678a5f9853ae8b4c49a262fd57921b86caff5fc349bee32ea0e9f9dc409f11f4"
    "cs"
  end
  language "de" do
    sha256 "a27e7dd6ea5040209aedcbdd5789729fbf9ba3880d5900e21ad002ac28b9401a"
    "de"
  end
  language "en-CA" do
    sha256 "d1791be4ab79c47651bf19fe3098b8aecc3fda3a7605c97673c2b1031878cb60"
    "en-CA"
  end
  language "en-GB" do
    sha256 "aae6bee1168ba3bb01bb320a2b2e0908cf9a7afae3b0e3e0a74e8255bdbb5f04"
    "en-GB"
  end
  language "en", default: true do
    sha256 "fb740d326f68490942b8444270193650afdd0869b5157eb98d527270e97fe94d"
    "en-US"
  end
  language "es-AR" do
    sha256 "dd7b12c2c9fc241ae688db4fda798233fe43029027f4412c5707c3ac415a8dab"
    "es-AR"
  end
  language "es-CL" do
    sha256 "fa9d61ca2e680bbce7266f41fc95218f982e028f01a99fb5616c48d60c59a0b9"
    "es-CL"
  end
  language "es-ES" do
    sha256 "e532c6029bc11ef46f4668f6c6f75df6cc7ad48f511b0572991f06a1b913b13c"
    "es-ES"
  end
  language "fi" do
    sha256 "24c55549105a8bb81b2138a225fc0986ca01e4e781a64a0f4a1a884d4824b6d8"
    "fi"
  end
  language "fr" do
    sha256 "09030dc07f1a134a10ffddc19a4039ed74aacc071c3628a9490346a297067660"
    "fr"
  end
  language "gl" do
    sha256 "00eff19fc54ceafb5d7b3f2d87b12bb52b6a0cf792d1f0bfec20b4bbc4aa2089"
    "gl"
  end
  language "in" do
    sha256 "6d02b3c8851cb1c9e4d2c194f9f9250abd1d53f3bd55838222e0b7cb059d4c11"
    "hi-IN"
  end
  language "it" do
    sha256 "be5b08476b20d4b976d06aa10aab102dd7e711f9545adcba662e70aa95f8d2b8"
    "it"
  end
  language "ja" do
    sha256 "c6b45912a908564b73907f14481450e40e747af22f396737f67a6bb7f4e3a4ce"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "0a615b22850929071a2b80256948bfb729104fdeb2559bfc29dbb4f3a0c41307"
    "nl"
  end
  language "pl" do
    sha256 "1f477877dfae26dc11b23825eefe459f66cde812288a4059f02e388360a4221f"
    "pl"
  end
  language "pt-BR" do
    sha256 "754402030cafdabe6f4bdd8c16ca5720023403c436c0c56bc82cd887257ccf72"
    "pt-BR"
  end
  language "pt" do
    sha256 "a7762710f499cb05cc7dd8dcc72dd78a5e60418e66575169d9dff1fd7b0bbebf"
    "pt-PT"
  end
  language "ru" do
    sha256 "c8df877254810867ebb75c4da1e8413ee4e8bc1c6f4b7fe558182e3cd14a4713"
    "ru"
  end
  language "uk" do
    sha256 "1809958c58432c786297f2420d04f710f6d1dc9cd6cd567a44432fc8a007e5ed"
    "uk"
  end
  language "zh-TW" do
    sha256 "3774bd249a019f8da12e556b1fb5cafa5de8cf66f6af744bf1dae1bb538a97f6"
    "zh-TW"
  end
  language "zh" do
    sha256 "0d04483be004342760fa211c0a7cfb5cdda8519cdb4c8f7ba85be61c5a93c8ee"
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