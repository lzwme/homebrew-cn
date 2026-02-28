cask "firefox@developer-edition" do
  version "149.0b2"

  language "ca" do
    sha256 "bebdc6484a39b1947d63fdc13582a7cfa1ed33f2522082aa6e508fc6a663b8b0"
    "ca"
  end
  language "cs" do
    sha256 "9ecb1f658967ca219b13d8c15f3dac6f3a0ee114d46ea216affcde7254d3ce38"
    "cs"
  end
  language "de" do
    sha256 "ed106fa4d836b8eb4beda05d94c5aa555680ba5d733b39fb431ef85c9236ff89"
    "de"
  end
  language "en-CA" do
    sha256 "55bf5a2505400e117734700377f31b4bb5efa879cb5a90dfd73a1f77d54a8d6e"
    "en-CA"
  end
  language "en-GB" do
    sha256 "10691afdf0023a881ec7a2c44b4ebf750fb36d1f9d88c38187e6982f91a16521"
    "en-GB"
  end
  language "en", default: true do
    sha256 "f9f4bd55b0faea74fe70c14980d72b1a96ec95ebbcaf13110fb345f4fc822849"
    "en-US"
  end
  language "es" do
    sha256 "ea1d2fbea4febc0f837e131ff96c96b3b5a29aa1424976e84478ade4ad565a68"
    "es-ES"
  end
  language "fr" do
    sha256 "091133b152556a6b8af423d0c029d07bc2519404304e1da032c3bfd97c480710"
    "fr"
  end
  language "it" do
    sha256 "bc9375f227d8ee00bcc4785031799d864a86d8af1d356aaaee4b923be5a8cb73"
    "it"
  end
  language "ja" do
    sha256 "b6d6bbab39c594a75d3fda35837e24b09946515813059b1191e8403076cddbc5"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "02ec8fa31ef9cd940a00e7aacf678af39a3151f8e652cc44290a6d94744d3fa2"
    "ko"
  end
  language "nl" do
    sha256 "a864f670bf258f19fb2a2f71940b6d2583c18980ab3c9f7e0a48ad26cbed23ed"
    "nl"
  end
  language "pt-BR" do
    sha256 "6c177956827af5a5b3af8ccee803cda3518721a3adc1064de947fc0ebd955e3a"
    "pt-BR"
  end
  language "ru" do
    sha256 "c84af9eafed0d8cf5e57df590efeac84513f493ed16e92282e495e014fd0b96c"
    "ru"
  end
  language "uk" do
    sha256 "e90020493c871be8ee2e7a5b0f44a0c07335c90d692ffd49643855bc2642f2b2"
    "uk"
  end
  language "zh-TW" do
    sha256 "e9e0b7bbdd88afd04a27de5cda794bb8c0c05e1f15fd824e758a0ec28b950d47"
    "zh-TW"
  end
  language "zh" do
    sha256 "d511151d43435eb933b763009f4cebee48f5f18d49390225536cc4108aa366d5"
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