cask "thunderbird@daily" do
  version "152.0a1,2026-05-07-13-39-00"

  language "cs" do
    sha256 "c14410c0f30617ecab848c20f41fad0f05624166b943d98449efb728f9553d6b"
    "cs"
  end
  language "de" do
    sha256 "00e93bd307336d1c659baf0f0cee4f0c53e50a365415a372a30b5e087406daad"
    "de"
  end
  language "en-GB" do
    sha256 "d1217b5ef98df55539875d2bfa32d9aabdd194c3c5e36ad79435307fc8c325ad"
    "en-GB"
  end
  language "en", default: true do
    sha256 "1b396988281e63aa897b45db3fe484fb3d9390aa342ef2aa1571e63eeb1c5f0f"
    "en-US"
  end
  language "fr" do
    sha256 "c5bbb751829ed9e680578ec4d450208b8585e70c3b552629b298d9245a47d135"
    "fr"
  end
  language "gl" do
    sha256 "2f14f44f90f906fbce47e84a451e49ff3c3f59d3ef1e8be7b544be01c86060df"
    "gl"
  end
  language "it" do
    sha256 "e2992c28294550c834f886e3b0dfc83e74fd347f6c1c5b6144eea92d819bc6bb"
    "it"
  end
  language "ja" do
    sha256 "faa6c7c9e1ae3bd44f36b1edb0c0fb43eb419620d4b983d2b8b29623fae2c2ec"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "1f25e6a84ba3ff497553b23f4b2de75b3d27a2fe21d41d94b31ee6a394935614"
    "nl"
  end
  language "pl" do
    sha256 "1d196c614651a8cb92651a0193f0f629355a09c61a1a85d669c49c35bad68369"
    "pl"
  end
  language "pt" do
    sha256 "0d94018daf11bdaa729193f7285e3a19fa11e0d17c7d40846122ce55cb845266"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "9201776f54939d5ed37aa6acb95f29a12d4a0ae78ce77667acdd464491b4fa60"
    "pt-BR"
  end
  language "ru" do
    sha256 "22af123322738dd4554c53db39bfa17d150403027f275b64f1cf196e507f0712"
    "ru"
  end
  language "uk" do
    sha256 "d6f9351541341ae6c22bfa2594df39a920fb41c0a7d5403804c23a4f404df757"
    "uk"
  end
  language "zh-TW" do
    sha256 "666b3e0f46f12d7b6295b5eda790cd13b40b605a71c2210e85e9d1cf49d7c74d"
    "zh-TW"
  end
  language "zh" do
    sha256 "5195c2480172455d8e79a952e5a335427ddf84a2c6758f1b94812f000486c1c7"
    "zh-CN"
  end

  url "https://ftp.mozilla.org/pub/thunderbird/nightly/#{version.csv.second.split("-").first}/#{version.csv.second.split("-").second}/#{version.csv.second}-comm-central#{"-l10n" if language != "en-US"}/thunderbird-#{version.csv.first}.#{language}.mac.dmg",
      verified: "ftp.mozilla.org/"
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