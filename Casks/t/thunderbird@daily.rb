cask "thunderbird@daily" do
  version "152.0a1,2026-04-30-09-46-14"

  language "cs" do
    sha256 "20c6ed478dad85405e9dd5407885018b6990d59384e99d2910b7bcf1b3f9b6cc"
    "cs"
  end
  language "de" do
    sha256 "00a2ff4319ad3e14158537ec4595ffff999e45ea5b252b4a98e6055cef3a6fa9"
    "de"
  end
  language "en-GB" do
    sha256 "fa08e680a52cbb5e62718b9e5afa878063e32d9759549c631bde0319e77a7737"
    "en-GB"
  end
  language "en", default: true do
    sha256 "51d5549a9aebbf79f84c2b00e5e4590496340d6bc148f4ddeac03fdc873f87a1"
    "en-US"
  end
  language "fr" do
    sha256 "ea26ef873ee1e3dc52737a21e5f6733ab6e79a8389d6c31c87f351cb824198d6"
    "fr"
  end
  language "gl" do
    sha256 "ac2648fddf2a182bd5df9be70cd8f4bcb63814814690dd9a55227c3e6ae7502a"
    "gl"
  end
  language "it" do
    sha256 "ca45112be76d8c06de7ca7f1ac463fec05d6170b0e4f550c20d515e9b83b3040"
    "it"
  end
  language "ja" do
    sha256 "677491aaec4d680622f8ff2c4e0f401b408e7ead3e8a1a64ccf4c1ffd200ef1a"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "1d1a9d2f3a4051e02d3ae7c93d1f5f9b238aca0e0a36f83185ae77191700d275"
    "nl"
  end
  language "pl" do
    sha256 "60ac4701d4b8ab1aaf8414a13f119ced399680c2e5e6e4369cb4ff9227c4bfa4"
    "pl"
  end
  language "pt" do
    sha256 "c0e14181103fae6646732a6e5f2b4d9112af6328ed7bfe350a995c4b89090a9f"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "e31388488a91b8b1d0c34533e50959350549aed10b8880d10f853e2a134fe16b"
    "pt-BR"
  end
  language "ru" do
    sha256 "153a23b91d70bb8d89685b2fd85cedd7014cd15562692cd5b5c5ed1260e48b87"
    "ru"
  end
  language "uk" do
    sha256 "c9a112341fc3bccd0cd3cdfdce96f8a7ff36b074edf180af49ce57f8d4140f05"
    "uk"
  end
  language "zh-TW" do
    sha256 "53147e5674c726448b3b297cfbfaa3102d3b16645f1c7c6aaef226630f4a4e14"
    "zh-TW"
  end
  language "zh" do
    sha256 "efc1ab88356678e2378dc969db04e4bc91a7b384dcb139405cc1a017dae1103f"
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