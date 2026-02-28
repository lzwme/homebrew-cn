cask "firefox@beta" do
  version "149.0b2"

  language "cs" do
    sha256 "42ff2e3f00ea71c4bb30615568d09e2e5840d1f51dbbed343a9b1c2a9cac261f"
    "cs"
  end
  language "de" do
    sha256 "2798f1c7e67a0555c87a1ee2eb16eadac80b0e3e015c8f526329798a1c6198be"
    "de"
  end
  language "en-CA" do
    sha256 "d4528ac27ccf1adaa518c4fcb330d572adcef94b0fd1310d70d1f1b05ef2dbce"
    "en-CA"
  end
  language "en-GB" do
    sha256 "90d4c60171eccac6e0eaa9c08dc59455d432ec6a2a05675a57707d50258d5ed7"
    "en-GB"
  end
  language "en", default: true do
    sha256 "cc697fd73992e677e7249be2a42d7e6e9fe1373841ecefe7009acfad113566fb"
    "en-US"
  end
  language "es-AR" do
    sha256 "4060cc08dad7fa94a69d273f0f2a0baa1a3e87fb06b2042dde802c26499e0738"
    "es-AR"
  end
  language "es-CL" do
    sha256 "c1f3135f3a191468a1ae72009006203b32cdc31537f81f2a9aa672226772274c"
    "es-CL"
  end
  language "es-ES" do
    sha256 "dc5b58aec89bd7a472961aa3dde266cb5d6dd839fe248c583d80a69528044102"
    "es-ES"
  end
  language "fi" do
    sha256 "5a3e9b0ff1839b96b66e5b6d65f445f77ba6b4762e5fb51518ae622242d0cbba"
    "fi"
  end
  language "fr" do
    sha256 "7b408944c5986c6b79f91e8780b059ebd2839abd338b7e861ab12676a2c5494a"
    "fr"
  end
  language "gl" do
    sha256 "67ac069dfbca1e4601ac063873456e524f5aa80e072d0a34f4871ff203e39661"
    "gl"
  end
  language "in" do
    sha256 "bfcf90555169d31cd7c73b7f57a976d889d162253cabc80f129221befc0c8024"
    "hi-IN"
  end
  language "it" do
    sha256 "b4d30a4148b89442d23a5e0f3a717881fd99372d678d65e986cb5efeb110a635"
    "it"
  end
  language "ja" do
    sha256 "f54dfac9f3db3f5ab65e91a8ba4d5777f5d45b2d3f7203a3fc5d685181b780c4"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "4a41138934ff8be03fe943822e92a93fd888bde2f20051ce287b02f7b2f1a008"
    "nl"
  end
  language "pl" do
    sha256 "6df69d45b490e9094541384e4c60a5caa6ede749da0f0bc37707c64c827d1d78"
    "pl"
  end
  language "pt-BR" do
    sha256 "0d79b76fc1b976266c11a2a23ef7fef4076013de444f2a2bd840866cd5d613ec"
    "pt-BR"
  end
  language "pt" do
    sha256 "ab13db2509b09dd5a47a76addf3e188d259c5473c1db81d093d6c89170b2e283"
    "pt-PT"
  end
  language "ru" do
    sha256 "7ad311ec84dad5e27dcc36290c300ec3ad4e49cf903e47a667173b25ff021cc0"
    "ru"
  end
  language "uk" do
    sha256 "06eb9bf1a7fbb4282f3c7c295700085a68edb5c29ddcb4a351049c85bc66363d"
    "uk"
  end
  language "zh-TW" do
    sha256 "a232332d935fb877ee8549f0bc7c3d1692debacad617c6bcd2ddc7ac3eeac8a8"
    "zh-TW"
  end
  language "zh" do
    sha256 "e535544d2ca857530a861ceedfb2f2c50235aae24a492f89a944b57e41416f86"
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