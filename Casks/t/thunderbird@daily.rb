cask "thunderbird@daily" do
  version "152.0a1,2026-05-05-09-00-34"

  language "cs" do
    sha256 "78c51b5c703717a12072ed4dc79d47623ab24ba0d08e266a872a49da4ed9bb04"
    "cs"
  end
  language "de" do
    sha256 "2802871e8e96611b48d5999bff91b8e0dfdf7c394a17a5d88181ad2775f79227"
    "de"
  end
  language "en-GB" do
    sha256 "c3db82f4e4fca60a7745cbef0b58d8eeee3b7a5496119d0e74c8934fb67f59b2"
    "en-GB"
  end
  language "en", default: true do
    sha256 "51bdab42eac22dce2c16e0a2ae10a18a1dc1c88b9ad83a3dc09ed0f0847e516a"
    "en-US"
  end
  language "fr" do
    sha256 "91fd7a8d60247cfc818ed5724b2a99649f3e7fade4077d7cf78618b64fd25958"
    "fr"
  end
  language "gl" do
    sha256 "5c3d7134ffc1262f5e3265603f6ab50c55e242e16334289d61d7576ae134519f"
    "gl"
  end
  language "it" do
    sha256 "9c8ee367dcfb9055d940641a12ca92d44388c04d1203000049750bf6714115f4"
    "it"
  end
  language "ja" do
    sha256 "c4320ffc3746c839be0ed518a82dca566f2262bd95bfec13fdc84cb2e2978d64"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "1de9d80728ac25d1317ac95113500e8c3b11b09370a0d0df20d58b08fb92ddff"
    "nl"
  end
  language "pl" do
    sha256 "d6c13dc50116c807b57ec843110ace50a1c04ac9cd77e72de288ce148c4d8053"
    "pl"
  end
  language "pt" do
    sha256 "8e4b96977d88bfa1410209ee9e590ad8b57e9ce4ff3799ee2ca92b9f7c5da72d"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "91db39a58020d6e754794bff4378d803a48b63eb827fba08e5a7b1abb2a7cd4d"
    "pt-BR"
  end
  language "ru" do
    sha256 "c686a0ab1d38a9eb359f362ef511bbf5e839cd5c3827aed28711d4205c9e88cf"
    "ru"
  end
  language "uk" do
    sha256 "b0ea9d395b7b39a4a18fc614c85c37c49ae41246a3ab948d8188e6a184d93a45"
    "uk"
  end
  language "zh-TW" do
    sha256 "433dfe81b09522cd1e2ec58695130c474a652ad060b0b3ddbc48b7e1d9161b5c"
    "zh-TW"
  end
  language "zh" do
    sha256 "ad2bf23e3c0ba9b5e10b9f895a4012e6fd364f7eb68d015c9e7d4febd10f473a"
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