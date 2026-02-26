cask "firefox@developer-edition" do
  version "149.0b1"

  language "ca" do
    sha256 "4db01378efda96c3aa92fb9fd260c7981f60edb8c8057e06179294ce5f31aa38"
    "ca"
  end
  language "cs" do
    sha256 "6c7b037b2d2d28af2709e553e1fb3ec7a75eeeab90bb7006950312813af83901"
    "cs"
  end
  language "de" do
    sha256 "5d407d3a44c1ed692c30769f61ffe4c72c03f381c0a2d6c6ff7ccda9c209f86e"
    "de"
  end
  language "en-CA" do
    sha256 "add78c348322449515f048881d7f14f9a21dd18fa1d96139c347e587ccf46d57"
    "en-CA"
  end
  language "en-GB" do
    sha256 "3d20ea071468c8f9debb940d10e3d99df68aca697aa8a382ddcb8e5b9a23ec31"
    "en-GB"
  end
  language "en", default: true do
    sha256 "094584fabaa4ae110ac3d8883775fc6d76820f4596c89136e501763aae4b8110"
    "en-US"
  end
  language "es" do
    sha256 "1d000385047f471d1f137f947425363a892ba0f44dce7bb50e04b0f5e513cbb2"
    "es-ES"
  end
  language "fr" do
    sha256 "51ffce0459a6e24606a6452053d45b8ec7f4783976c9cad0f11ba783cf6c1760"
    "fr"
  end
  language "it" do
    sha256 "b9ffb418ced565defdfd5a9d71f14a29ea910140311f558b461621797d9f0233"
    "it"
  end
  language "ja" do
    sha256 "0914b4c54a0f5336e6802d1ad69c87f23007bef9687e69129539641a361b78ac"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "a82e2ebc7538945cc875a8270a98f5f485d97bf38e3050ff652fda9d5a0800c1"
    "ko"
  end
  language "nl" do
    sha256 "acc19668135d36903f482ee2e29aa78f5983bace22e82bc0f3de12a43b3dad6f"
    "nl"
  end
  language "pt-BR" do
    sha256 "9df8dfcce87549302da4f5ab64a6baf07e1f06f1f3c63e355e6f209b6dbb3fc0"
    "pt-BR"
  end
  language "ru" do
    sha256 "0589d483fb8aae058d08fbad49f303fef3c39f00a43673cd0fd8e21e4264a994"
    "ru"
  end
  language "uk" do
    sha256 "6c6065417610c3b33c70af53d45fdceeadc7bd18704ccc4bc078de90fde2d528"
    "uk"
  end
  language "zh-TW" do
    sha256 "6029b9aa6df020cdbeca5d6be27408138940706e934a80f9e4bdfc72bb047c27"
    "zh-TW"
  end
  language "zh" do
    sha256 "c002298d4e179c37177330c72511f030f22763c55cd0f8ecc70047ec319cabd1"
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