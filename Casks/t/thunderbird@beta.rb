cask "thunderbird@beta" do
  version "151.0b2"

  language "cs" do
    sha256 "23d9f3252cb5770c5192c6db70c56e541c466dc84c2d9fced6f5fd4a2d755a7b"
    "cs"
  end
  language "de" do
    sha256 "b122766f30037a9f6f24cf210b3cdf009cbc90384386103a3244bc1227d31a38"
    "de"
  end
  language "en-GB" do
    sha256 "690fc07bc8acc01aad1e2e9a393c37c96fd7b6dbbd11829bb10fdf31a5cc4fbf"
    "en-GB"
  end
  language "en", default: true do
    sha256 "a62b2460fded6500177c147a4a8e866fe5913882aab39ba3f655d744c9407b18"
    "en-US"
  end
  language "fr" do
    sha256 "b1b33ffe266929da3e3b347dc978c7098329c8214f7ffc177130586c78567f3f"
    "fr"
  end
  language "gl" do
    sha256 "ba7fc38dd0f76adc6f4147dc9b6e1e7e59c93cc679c8ef8c9718aacf2615f3dc"
    "gl"
  end
  language "it" do
    sha256 "3f09aa8ca8bbf5bd27b979af34d3194a16391ac85e161c59d4cddc4746622a23"
    "it"
  end
  language "ja" do
    sha256 "6750cdabc7aaade5c52ae25ef3ddc38a1d0aa7da727f3b73e56d682417aada46"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "f082f2968a4b050f22f1405f6261e76a4ea4eeb88b52a1bc955e7b5d298a783f"
    "nl"
  end
  language "pl" do
    sha256 "e71b625a3533d3d4bcd70dca55cf3259c3fa9fa6bfaf675bc73a2de78754b4a4"
    "pl"
  end
  language "pt" do
    sha256 "1c3d2b3ba37ed6ccf1e47ecf23d0fed888c12234f09b6852c606489707365cc2"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "33706106b1e8aeb411f54937858ce53bc93c3b587d425676e0fe21cfd41728ca"
    "pt-BR"
  end
  language "ru" do
    sha256 "0dccb8aaf9a058474e564863b4f56ab51ea88dc2c5087b49fd7e56f8fc8af56c"
    "ru"
  end
  language "uk" do
    sha256 "9739f65cbe3e1f87c8e3b0e9a3198f77eda545f1b77b8805543c186cd6784989"
    "uk"
  end
  language "zh-TW" do
    sha256 "9103490a5f301b468a9b610d13847baa67905f740448e7cef1dd56b98173cb9c"
    "zh-TW"
  end
  language "zh" do
    sha256 "e002634a870c6d1860ce2fa35d251c99abf68aa730b8520900c3ecc8f3d8acab"
    "zh-CN"
  end

  url "https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/#{version}/mac/#{language}/Thunderbird%20#{version}.dmg",
      verified: "download-installer.cdn.mozilla.net/pub/thunderbird/"
  name "Mozilla Thunderbird Beta"
  desc "Customizable email client"
  homepage "https://www.thunderbird.net/#{language}/download/beta/"

  livecheck do
    url "https://product-details.mozilla.org/1.0/thunderbird_versions.json"
    strategy :json do |json|
      json["LATEST_THUNDERBIRD_DEVEL_VERSION"]
    end
  end

  auto_updates true
  depends_on :macos

  app "Thunderbird Beta.app"

  zap trash: [
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.thunderbird*.sfl*",
        "~/Library/Caches/Mozilla/updates/Applications/Thunderbird*",
        "~/Library/Caches/Thunderbird",
        "~/Library/Preferences/org.mozilla.thunderbird*.plist",
        "~/Library/Saved Application State/org.mozilla.thunderbird*.savedState",
        "~/Library/Thunderbird",
      ],
      rmdir: "~/Library/Caches/Mozilla"
end