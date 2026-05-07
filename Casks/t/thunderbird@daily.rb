cask "thunderbird@daily" do
  version "152.0a1,2026-05-06-09-05-55"

  language "cs" do
    sha256 "5d9500c3101a21a1cedb76631ce81dbb50f11db2e99b76f5741832abb89a8d65"
    "cs"
  end
  language "de" do
    sha256 "07791cc4b7ed990a268705ffbdd4c6dad936527e1dbe7544b432e182e7de7c6a"
    "de"
  end
  language "en-GB" do
    sha256 "5a788a22860ab4d53fd28a21b18878c3fbdc86e01155f17c703e3cb9bb693c9f"
    "en-GB"
  end
  language "en", default: true do
    sha256 "911ac9b47212d91e6d03d92f6a8ee8463f145def867179231f7aea429e8b41e9"
    "en-US"
  end
  language "fr" do
    sha256 "c52295a0aac27213edeaa644ccb1c7512c9d75eaed32b5a112581bf002eb42a8"
    "fr"
  end
  language "gl" do
    sha256 "a731912e453e1c567c4b2b496df368f6ca083211d17cec62def8449710ffcc10"
    "gl"
  end
  language "it" do
    sha256 "11f54b847183324fdcc90c02680d20540d120618c2750168e3b42729b54b1b3d"
    "it"
  end
  language "ja" do
    sha256 "ced042b448ca8a73d9cdbc9eb3c648a20993a83d10fc4bef26e90fb3ef8f4013"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "a065568fc31dbcbb8f3e20f35bad0aced40c9a8d68677ac2f9b8293b51cc3f87"
    "nl"
  end
  language "pl" do
    sha256 "98bcd14b8eac3d182ec8a5b711c31a13ba571b8d59ba0e546f5fd97575c14743"
    "pl"
  end
  language "pt" do
    sha256 "547dac156aee35b2ed202002da349b1601434162134e646b3ae8b8cd29aa5008"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "d42e7775761690dc4a316320aad5c6a4851bfdd4fda28a459d513c93284d4b79"
    "pt-BR"
  end
  language "ru" do
    sha256 "268b2557e8f8764a52d7eaeb9d7ed92dac049d06319596d3d0a3b0490cfdccb6"
    "ru"
  end
  language "uk" do
    sha256 "b5be66d2fa90ae7eb2bc4c63dcccb0210227ee8910c46cbeadf215c085b3b9a5"
    "uk"
  end
  language "zh-TW" do
    sha256 "b5688f3295e1335c33fa2ec51fa5d501717fadd80a443b3953b9a01df0eb3e88"
    "zh-TW"
  end
  language "zh" do
    sha256 "0e2090023fef599cde5ed3a8ad1ffc6bd5a23aae8af48a0fd9ed295e7a362d45"
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