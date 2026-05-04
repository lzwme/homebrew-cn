cask "thunderbird@daily" do
  version "152.0a1,2026-05-03-09-26-14"

  language "cs" do
    sha256 "949bbae0e285d1b11c21872e3a15a3bc5045ff06bf3c7b8168388f95b7e6b085"
    "cs"
  end
  language "de" do
    sha256 "755640fabc7076860a44df0028689c955ebdfcace93f12eecd0654c3be106576"
    "de"
  end
  language "en-GB" do
    sha256 "b82e6ef33d0da9295f8f248d695d9e96534817d64c2b123451f8910c5ddeede3"
    "en-GB"
  end
  language "en", default: true do
    sha256 "1c555e4ca6e84456ad4adc2657320e146012e0f63c8e9362b9f7ad3bdc0a0820"
    "en-US"
  end
  language "fr" do
    sha256 "d31262db29c11f46ab04170c3b65548761304df4f0e82788766c0105b84a69e3"
    "fr"
  end
  language "gl" do
    sha256 "32f8b8c8885d0159c63707254cf32dba77e58ea59aefbfb29b5aa29d3f06e9d3"
    "gl"
  end
  language "it" do
    sha256 "44021f456a9055ad3be647643a34790bdd1fc0ab3598d06d870afa5f48ded6d6"
    "it"
  end
  language "ja" do
    sha256 "0bca73716ece1c54ccefbfa007db43ac211463177b3beaa0f6fcaddb26e70ae5"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "fdb47627dfd2b58ad4c59b249dc889a22226d3d676630a694c370283ade0e16f"
    "nl"
  end
  language "pl" do
    sha256 "71f2b192226221efa2004e9d4985effd80855aea8f5644bd1463d9fe86965264"
    "pl"
  end
  language "pt" do
    sha256 "3adcb48e54321015bf2b8349fd1ca164f2e8e0ba3f3e2e062670c82970080747"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "f5eaceeae639440f85f4649f68a1ce4f87351bc812815dc02e95f2d0ce33ad80"
    "pt-BR"
  end
  language "ru" do
    sha256 "32ed7bb6e638aab5927a44a1e49347b69af09b020ee3bb2725618c85cff28650"
    "ru"
  end
  language "uk" do
    sha256 "95ca1571aee79f2a5689a2c89af3445c2d4bff90b23fb6656d12935dbf8c008b"
    "uk"
  end
  language "zh-TW" do
    sha256 "2907f9b74206c3285edbae7d9f9ef0c348420c91f28ac8d13060a61e4a112bfb"
    "zh-TW"
  end
  language "zh" do
    sha256 "dd93ab818012f63a13b2ec13fb8616721bc9fb1f220f7060e09c114fe23a93b2"
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