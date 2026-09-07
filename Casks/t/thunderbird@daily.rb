cask "thunderbird@daily" do
  version "157.0a1,2026-09-06-09-58-27"

  language "cs" do
    sha256 "cf764ed822edb7c46e2eddb7894f51f347ac22dcd9ac42de885e6e72fb6286da"
    "cs"
  end
  language "de" do
    sha256 "f54a94d100696e187c8a473187bf42c46ebd5c0bd23cdc2a0bb9eceee91e6fa3"
    "de"
  end
  language "en-GB" do
    sha256 "7223407b717f3ce1f93acd1b2dce1d6165e963b434f5f626d8142418ca59017a"
    "en-GB"
  end
  language "en", default: true do
    sha256 "0ea6d00795574b47ac7e4f115cf65b4924b41ca51ada836706b6af8aa545a8e1"
    "en-US"
  end
  language "fr" do
    sha256 "95d82ca3c6c0c52d331bc5c1bbd7622b78695c584c38194d8c5d979e5cc12cf6"
    "fr"
  end
  language "gl" do
    sha256 "60328a00a0876625f4b34286d13f0736f05d2b6209ef9208755f01b1f695cb27"
    "gl"
  end
  language "it" do
    sha256 "2acb6a296b2f4c0e8e7cca15521d43426168499ed8656ed2d86d522a99193c9c"
    "it"
  end
  language "ja" do
    sha256 "cdc025eaf1e38744babcd46fd61556cf46af814d4492a2d5dc7f42c7b3140225"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "424eff5179376d8de9c477a68718a1d3d883995937542e27eb0b694c40aacb11"
    "nl"
  end
  language "pl" do
    sha256 "35d128b0ce4a1f8f549dae4383294b787a9f1c06280063eb55582c7f569fbf07"
    "pl"
  end
  language "pt" do
    sha256 "b00f9a563d7b59d05b17add7b20911f58835b39093827b8c6a4fb630d0b3ee84"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "1a9e855d6a52cc33a4468ef8be558cec61637ea9310cf2e414e691eedbe9cb0b"
    "pt-BR"
  end
  language "ru" do
    sha256 "7b649ea57f0183ddef6a326491273ce43306ef7f469605972f294359f035cdcf"
    "ru"
  end
  language "uk" do
    sha256 "5f37e84dbd5a0e64c2d983a65c45236061e43382942d93ccd57e0d37dac29b16"
    "uk"
  end
  language "zh-TW" do
    sha256 "fbcc927a2975cff9b06f6cb998dd1c06a442b7486baeee7ecfae2f6f1c24cde1"
    "zh-TW"
  end
  language "zh" do
    sha256 "33bd3be9aaa07ac28af5383ce774f2632d40774b11241fa09c1790e117f6502a"
    "zh-CN"
  end

  url "https://ftp.mozilla.org/pub/thunderbird/nightly/#{version.csv.second.split("-").first}/#{version.csv.second.split("-").second}/#{version.csv.second}-comm-central#{"-l10n" if language != "en-US"}/thunderbird-#{version.csv.first}.#{language}.mac.dmg"
  name "Mozilla Thunderbird Daily"
  desc "Customizable email client"
  homepage "https://www.thunderbird.net/#{language}/download/daily/"

  livecheck do
    url "https://product-details.mozilla.org/1.0/thunderbird_versions.json"
    regex(%r{/(\d+(?:[._-]\d+)+)[^/]*/thunderbird}i)
    strategy :json do |json, regex|
      version = json["LATEST_THUNDERBIRD_NIGHTLY_VERSION"]
      next if version.blank?

      content = Homebrew::Livecheck::Strategy.page_content("https://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-central/thunderbird-#{version}.en-US.mac.buildhub.json")
      next if content[:content].blank?

      build_json = Homebrew::Livecheck::Strategy::Json.parse_json(content[:content])
      build = build_json.dig("download", "url")&.[](regex, 1)
      next if build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true
  depends_on :macos

  app "Thunderbird Daily.app"

  uninstall quit: "org.mozilla.thunderbird-daily"

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