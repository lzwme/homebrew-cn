cask "thunderbird@daily" do
  version "150.0a1,2026-02-28-10-27-40"

  language "cs" do
    sha256 "542004a5a4dba65d7186937fb3b550d6fd0379efcd9d6053ec41acd98796d839"
    "cs"
  end
  language "de" do
    sha256 "604a2ce8892f73087bb395d8312c087a7f80a9acf7653bd5eefc703431da939e"
    "de"
  end
  language "en-GB" do
    sha256 "4075a2bbb75ff9c0b722cef43de14b2e57d8417742ee8049097ef4aacc6ea4ae"
    "en-GB"
  end
  language "en", default: true do
    sha256 "6637c5719e79cacb1e11c2350bd07315e9e01611d6120d22f1cdb05b201aa321"
    "en-US"
  end
  language "fr" do
    sha256 "c54f506ac3dfee0b2108c272b1c430d4241d7bc1ebafd35a9d4e7029c1187796"
    "fr"
  end
  language "gl" do
    sha256 "809746763ef7b6e9a79ef479704fd245cedf2ba672c02e15f9c0933ecee30f5e"
    "gl"
  end
  language "it" do
    sha256 "5b17caec1a6ab55e1eca178e8afa824fa28225cdda519b0712b81d4843d9d6d9"
    "it"
  end
  language "ja" do
    sha256 "7001f61a176068b3c4129c4c11228bad2d741b34586228f4f4ebd356a7194b25"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "d47a6495686fe8544dd72c717492d7283819513244fa2400c87d4eeac549d7bf"
    "nl"
  end
  language "pl" do
    sha256 "c691ee5b70f7b5568e62af68aacf89d10831dea68dffd7b74fab5cb1b78285a0"
    "pl"
  end
  language "pt" do
    sha256 "123ea8f3b042327941936b953a1c77ce124c0f865ddc8242929e9f0ad6b1cb73"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "5228c3cf37fbc01cfed104d9812e324aab2b468cf6ca26fc1910619cca9df4fa"
    "pt-BR"
  end
  language "ru" do
    sha256 "f678de796203dab267108e9f2920e21d20ac42de71facce1164687baa3df8b96"
    "ru"
  end
  language "uk" do
    sha256 "06034d184fa915ac09d4a832bf094be402794e7279a0fc1a353ed5e6e8534d46"
    "uk"
  end
  language "zh-TW" do
    sha256 "a48e4f991eb060dd7368b4fedbcc318f20c6ffa7a80ae25a31d5d4675242cc98"
    "zh-TW"
  end
  language "zh" do
    sha256 "16df55635d5243c7e618cdecc8a48e917625a452bb34cf3806f1b0c96f084b50"
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