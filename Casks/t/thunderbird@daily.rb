cask "thunderbird@daily" do
  version "162.0a1,2026-11-14-09-48-50"

  language "cs" do
    sha256 "bbbc5a35c1d87d38457b838cc643ded002a072e424337e92553b4c7085e63caa"
    "cs"
  end
  language "de" do
    sha256 "5a25580bf683a2f623e644e87476bc9d6f69ebc925387ea2dbf269d9b93f9d7d"
    "de"
  end
  language "en-GB" do
    sha256 "00b73fe15a98b7992e911cb74447169df426d26ec232f5daaaf6161fd4d8f523"
    "en-GB"
  end
  language "en", default: true do
    sha256 "5e2c52bd8247cca4e4b882ec0e4d0c8eb20ec306480eb3653483bf5cf0d4c16f"
    "en-US"
  end
  language "fr" do
    sha256 "639c083120b806527a495e4a0f2dc161c2480698aacfc71af0c77d2ac644fbb3"
    "fr"
  end
  language "gl" do
    sha256 "7265c2b987481a68dec1d330ab9588d77a27913c147e9d0c15d24ecd049e3ddb"
    "gl"
  end
  language "it" do
    sha256 "843fe7046ab28169a90ab4b9cc023890f436a3166f26bd7eb1104ecbf9a7ce8f"
    "it"
  end
  language "ja" do
    sha256 "cd66b9b8ec364f824239d0ea86a08178c0b6dced6cf297a9a15e8ca5e859f781"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "2bb8e24b1155a0ac2fa752ab13ea85005e047b26e59a0833963491e58e400ef3"
    "nl"
  end
  language "pl" do
    sha256 "3bcd618b0495c7be9fc859dffa548ecbde3e66bd3a12d7eda863b6bd73c9014d"
    "pl"
  end
  language "pt" do
    sha256 "d15da7857174e843e4f8c090836ba2823a1601e9da57b0e8e4a61c9757e41ddc"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "0402d77d62121b0c070389455dc50d8823aa22ba45afd4f05368980b8a97f97b"
    "pt-BR"
  end
  language "ru" do
    sha256 "413a3168d3374fd6c46a17ee5b0953d4af27e61feeac12d37bb57fb4f3418203"
    "ru"
  end
  language "uk" do
    sha256 "c5404b1ad3381d4098030078f7d9e15c14f11887cee39ba65eaaa42ef23df9a6"
    "uk"
  end
  language "zh-TW" do
    sha256 "4121dd4d16d26f9360334aa667fbdf405d2b26504b87c72cbf7b3a7e28a81eb1"
    "zh-TW"
  end
  language "zh" do
    sha256 "03809a89ff84c1d1adb55de4ff2abdbb54da1e8cdc1b956d9060d7a5752571ad"
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