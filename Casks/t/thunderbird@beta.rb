cask "thunderbird@beta" do
  version "149.0b1"

  language "cs" do
    sha256 "8587dbbde3c6186b80b539f73d018d7a0da12a3b0df8ad87d3bbda3abfee5f43"
    "cs"
  end
  language "de" do
    sha256 "c737f95759aff55412b469c89bb989abd5113506d6ab31050f2c17fbaaee77f9"
    "de"
  end
  language "en-GB" do
    sha256 "5c708e089df5826e4fc98f512102821da5c3941a0c3c740fdf121305483c6042"
    "en-GB"
  end
  language "en", default: true do
    sha256 "8724dae893dea2a52716149220f8232c58b645f5c1fdc66b72f8817c75239c3e"
    "en-US"
  end
  language "fr" do
    sha256 "57d5302d50592e03c1042c7eef58ed53b7b5dd1fcfee8260597c8fd49e122831"
    "fr"
  end
  language "gl" do
    sha256 "1583f7603efe7e71e680a71464d607358d63218c78a41f8ae09c5bc16feb1874"
    "gl"
  end
  language "it" do
    sha256 "45dc92e55f88cd7d3c059907fb65d8a29b42cf416e66cefc185252b4d6785c7f"
    "it"
  end
  language "ja" do
    sha256 "8ce5dd5e63d3cf3d364092edbbbf3be386254adc8c7d3f1e60480cb070568294"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "ed688d351de7f5812d54a94a4bd43ee8f4898614a2a2c7973b81823bf7ba11a6"
    "nl"
  end
  language "pl" do
    sha256 "51be885e4a34a5998eff00061fe80bafed733b61f9c07549efc653e4901f1a2f"
    "pl"
  end
  language "pt" do
    sha256 "29b5ea86b28945868f43c75365909f81b9c5339ed37d4b3472d65afce91bd813"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "d717325748af43aa5e7201eb9bafe400add1da456f0ed1301d44bb99e917fa86"
    "pt-BR"
  end
  language "ru" do
    sha256 "d9a42534d713e58079490ec0a917b9aadbf3331203e3bf98c2819b483b225390"
    "ru"
  end
  language "uk" do
    sha256 "bc2ddf81dc4f07bbcd76304da66997d9ed6dce5927ebbbbbfce9305551a48e64"
    "uk"
  end
  language "zh-TW" do
    sha256 "e9405df27ad8d35bd29eaeb8cabd75fd025def86041f3a810cc0e627d24d5868"
    "zh-TW"
  end
  language "zh" do
    sha256 "2aae351dde7e8d96558efede361ba93ea994bc972bdc1f349dc3c03e3e845538"
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