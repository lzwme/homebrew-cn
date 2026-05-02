cask "firefox@developer-edition" do
  version "151.0b5"

  language "ca" do
    sha256 "3dceb37718caaa0dbdb0e32d1f66d148658db123c81a742712e3d95a97836353"
    "ca"
  end
  language "cs" do
    sha256 "41ded60ea58c1f5f4fd8970e86678705eb3886bb1ffc9be79ee79ffe8bc27246"
    "cs"
  end
  language "de" do
    sha256 "96b633fd30092b77b5dc973607747959f2c3494ba6e17464004e6d87af4720c3"
    "de"
  end
  language "en-CA" do
    sha256 "e85a72180049e10b68f1d0bae9a2f1e2b61ec2da30768f7cb0d710fccf6fdbfc"
    "en-CA"
  end
  language "en-GB" do
    sha256 "d7f28e999e79ede437f48d2d5fd356b3fa93f1c1d1c3f7d86faa9b916b1b8f47"
    "en-GB"
  end
  language "en", default: true do
    sha256 "e150e8f60c534b8ebde707410359c61be6b384a3b56c3e791d62c760d1161ca8"
    "en-US"
  end
  language "es" do
    sha256 "fa47db1587bebad631c2f5f75e976779d992d43c4e1e51d2c32f01b6faa4ed9c"
    "es-ES"
  end
  language "fr" do
    sha256 "3823e5130291a435538f2f8983129157835327dac7b03dcd0bc8fd5aeda1b641"
    "fr"
  end
  language "it" do
    sha256 "80a00b4b569ea82dec3f94905400be6eaa87ab09fefa43a0fc30a7053fbeb1c8"
    "it"
  end
  language "ja" do
    sha256 "b701d00f06f0c8d6479d8571926b744d8770864ef155703026473288e30d576f"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "c9ebea4f6a4300f10be0c805b4a9cbf500c782ba674375f8c3f8e31352749d06"
    "ko"
  end
  language "nl" do
    sha256 "da2f2ebe3020c02efe5846a3c49f049f3c5384705f90e26474c5609e26e2afa6"
    "nl"
  end
  language "pt-BR" do
    sha256 "fa75435dc522fbe396ca6bbc9d2382506ebcc78ef26704bd124e3c5f4f0cda97"
    "pt-BR"
  end
  language "ru" do
    sha256 "ccf94b38c09fdb91f4c16610bd0fb15f7dfb8d8af490e29fc6020f48f0710029"
    "ru"
  end
  language "uk" do
    sha256 "9522fafb439b0ebf18582e47241a2aeb133d616511e648e834d2a7d38d8dec04"
    "uk"
  end
  language "zh-TW" do
    sha256 "9fce6e20765a6031bb72df661c87be2417f7ae9faef16ddeb8c7fa1b0e87a2ff"
    "zh-TW"
  end
  language "zh" do
    sha256 "34c0c56f8ee0693d9fe39dabbab7206539eece46d0c5b840d66150ff174bceb5"
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