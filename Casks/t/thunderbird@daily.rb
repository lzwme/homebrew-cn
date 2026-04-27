cask "thunderbird@daily" do
  version "152.0a1,2026-04-26-10-54-18"

  language "cs" do
    sha256 "ecaa96f2b8befd64b5faf6a6f2f93da465df38d13095c7342aa95ab7386a8aff"
    "cs"
  end
  language "de" do
    sha256 "f22bb656a15278567e77b212d1019ac42385dc64e78753aca69c7ae95cd837bf"
    "de"
  end
  language "en-GB" do
    sha256 "6b497fd9a6d034a55855b9d658733296fb2f1adff231c9de5522fdec7862b7ae"
    "en-GB"
  end
  language "en", default: true do
    sha256 "750c2b24cf61d08fa17e4378496172a54252c6c4ea691ccef65b3cd65faf06b6"
    "en-US"
  end
  language "fr" do
    sha256 "ae90fe3fbca8ee811b0b082f7f93a31bec8e739e1b844acea7a3ac947f3071f5"
    "fr"
  end
  language "gl" do
    sha256 "794e56add763535457fe5ae76843e178c2265de9b0b32ef8f8bedbf161871105"
    "gl"
  end
  language "it" do
    sha256 "bf61cea31ed5525ea16be16808666df16364ca06831118e396d2abf30fc02e41"
    "it"
  end
  language "ja" do
    sha256 "75a1e1eaf28f2015715cea9513dc492fd2422daf6a41cdc703c884e6b2897262"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "5867a605ad8b9931e04d0aa6bdc4ffee8f07e0167ba428f5c6ef0e24e055b903"
    "nl"
  end
  language "pl" do
    sha256 "302ede768f9412c97338ff9c863c8c6adc9df50e180d76ae7f6cc0246b1c114c"
    "pl"
  end
  language "pt" do
    sha256 "dc95b2d4d8644129cc1e368168c7bd4deeee959c23043076b9231899012953da"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "6f005d2b47531e28b8fb5144704ef2edfaca1aa149fe5006ae3ddbd1073d1f22"
    "pt-BR"
  end
  language "ru" do
    sha256 "9959f9be40ea666722d4c538fd356013fbc47553c306aeae085cf80549f1aff7"
    "ru"
  end
  language "uk" do
    sha256 "e9275bb25e4214e1f38121cd8b36dcc5c1751ce1e7f781e5861e9b6af7bc465a"
    "uk"
  end
  language "zh-TW" do
    sha256 "7b03d02655c7be66daae73cc4a53ea24eb146f33cf5ab114e6f827870adb51a3"
    "zh-TW"
  end
  language "zh" do
    sha256 "cecfafbbf9c21f8d015edb4d97eb0a5a6d33452ffdc620381b83ce43475743fc"
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