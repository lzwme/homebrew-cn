cask "firefox@developer-edition" do
  version "151.0b7"

  language "ca" do
    sha256 "7040a693f1923fe36490a9a443d6ec0607fdf9ec7d00d272d2baa84cbf46d1d3"
    "ca"
  end
  language "cs" do
    sha256 "dfc5031c1a79f0293918b39348c0b52ceaede9e3b4c590772a7e77fbb725d29c"
    "cs"
  end
  language "de" do
    sha256 "95237b0b7cae91e30da8eba1ca3845b5caf07342a5412256538da726c9b44782"
    "de"
  end
  language "en-CA" do
    sha256 "86b3bb79cbc699e34a397d0b9569099795b83707d3f123dabddbad1a98bc41e6"
    "en-CA"
  end
  language "en-GB" do
    sha256 "51ab6ab8f9476729fb61ffcd593886fa9648fc770b41e137e8be250c69cc8f69"
    "en-GB"
  end
  language "en", default: true do
    sha256 "466d0350ef2a0f2ec5826893baaeed32be0d88dbfa135494da4d6d64987097f9"
    "en-US"
  end
  language "es" do
    sha256 "44a33d7747ff275276ba7f384faa3e2e0a297f3867e2823bef10cc6821112ea1"
    "es-ES"
  end
  language "fr" do
    sha256 "fe9794fc4767766d0707378a2d4eb61b69e4f3d7a5a4ae48c40fd6f7fe65db36"
    "fr"
  end
  language "it" do
    sha256 "4e9e88ad5a8ff4d4599ae0fee368e05a40105618d419c439bc4e6ac74f1293db"
    "it"
  end
  language "ja" do
    sha256 "8003d6e09b8c613905ebcf333a8f6282fb018e8cb9985f734b62f13dbf8c53c3"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "8dcb44daff318e99fa935a62e6ff4788b42a814c8754600dc196ad64f3cf6c00"
    "ko"
  end
  language "nl" do
    sha256 "88d3918bb3252dd889db2280b451a1da8e76d67abd62f3e94078863d5912d08a"
    "nl"
  end
  language "pt-BR" do
    sha256 "220559a27029e4b3a7415b4115f6b4ec39fc8086a8e9d1d38c067f8166902afc"
    "pt-BR"
  end
  language "ru" do
    sha256 "3addcb744f30d1092e2cc4abb225a6a04d2d1722cac7a957f17b9297e970b14d"
    "ru"
  end
  language "uk" do
    sha256 "8d8cd7a3486e0e5233c71fb0049ecb2ffb48df1b10d8da1d065b42d3a3325e5c"
    "uk"
  end
  language "zh-TW" do
    sha256 "64ba284b5f8e479c585ad3141c7908ece33d957b55fa986a276d940681eb2f26"
    "zh-TW"
  end
  language "zh" do
    sha256 "cb39c883b6dfff64039b51830ea355efb384565056aa7dad16335fddf2599f75"
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