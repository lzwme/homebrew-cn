cask "thunderbird@daily" do
  version "149.0a1,2026-02-23-09-39-07"

  language "cs" do
    sha256 "f6bfab5c8dd1f81677ff35348a8e36cbdc14085beb83c80d446ee2c51217e9d4"
    "cs"
  end
  language "de" do
    sha256 "e3748cd73bb17085144ecccafbc8eb7081ad06efbeef04f5f306d260def7da92"
    "de"
  end
  language "en-GB" do
    sha256 "6150e2f564d2f3d0bb6a7b28134c8e5a34bac69afa18a23ef3af4d80713a64d1"
    "en-GB"
  end
  language "en", default: true do
    sha256 "137b965e8b5ec9453718ae7854f16da2672a291a29966278bd99116fd95db2cb"
    "en-US"
  end
  language "fr" do
    sha256 "a21461c9279bdcb9c7db01c0c116eaf906b4a7c156a81e4149d2e4d4216ff529"
    "fr"
  end
  language "gl" do
    sha256 "326287e88e38239f6766842bb31355dba70ba11dbb3e93cb466ad8affc2a2905"
    "gl"
  end
  language "it" do
    sha256 "58237072d10c465ef9bf4497d188c711454e3e1fc87fecca1523b500abb793ed"
    "it"
  end
  language "ja" do
    sha256 "2eacd3fdbe2eb263cbfcd07de498ac84437789d0bdd54939ca5ca43a4c5354f1"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "3d4cb13278d5f53b5724c4a6da38ef8148eb8a8b0f7c9fbb17746ce0517e739a"
    "nl"
  end
  language "pl" do
    sha256 "b8c30dc87268d029bee23ddd268aec18b26ddfde7c11aec1ab88ea513ec7ac37"
    "pl"
  end
  language "pt" do
    sha256 "52f9a46389ff18ced7379164f5fce8fbfc418cfbd7c0cd069986a198d418d630"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "5197f5436a0b961a1fcca3c160f62ca03b372f614032cba53fec611b8cf1ebab"
    "pt-BR"
  end
  language "ru" do
    sha256 "abf53c0d0b925739a227b29796a9d0c51d2be12a6a86798b2a68adfaffdb58b3"
    "ru"
  end
  language "uk" do
    sha256 "7f0c5e6a845185bdf9a7b6f8968c90a2d7b853389c22b06547d1bae25e4a7fc6"
    "uk"
  end
  language "zh-TW" do
    sha256 "4f84b4db1a9c0fd2aa6431ada0082b38c2e034860303464a1dbe9e3003b1d79e"
    "zh-TW"
  end
  language "zh" do
    sha256 "adea3415dacc73e8d10ccbe3a25c0bf3fcc554846618974c8d257e8c9c653cd7"
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