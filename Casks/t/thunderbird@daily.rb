cask "thunderbird@daily" do
  version "150.0a1,2026-02-26-10-40-59"

  language "cs" do
    sha256 "68f3896621be88eccdc8ceb9a6e60f571dbc58213f59334cc1d36d936a9b24f1"
    "cs"
  end
  language "de" do
    sha256 "daadd43b27cdc644c7ba1f7d2e9e138e79229d2b09b15e3d2095a398928490cf"
    "de"
  end
  language "en-GB" do
    sha256 "88739ecd46973d7f3b04e0a153e0bf4f8856b73b281addfb9dc448039c75e573"
    "en-GB"
  end
  language "en", default: true do
    sha256 "5405681fc2c364c33b6028ae3b1dc58b5ad68886137b2cc8b7774dfac3543138"
    "en-US"
  end
  language "fr" do
    sha256 "4897a8824b55a9939d0bc3f49a78b27e60f8ffb5f6e1f991a797930d9816e218"
    "fr"
  end
  language "gl" do
    sha256 "8c53ec1982e0a88f49ededc9692efbc459d803726ae5b2aeae02e3c1042b3aad"
    "gl"
  end
  language "it" do
    sha256 "f431b1f8634c847291938ba698ac9a99845a4edc5e2f47d269ad4842f720e4b5"
    "it"
  end
  language "ja" do
    sha256 "14ee76ebe2f0c136b5ae08cad582d33cb983c676c4ba7b7ec4766dc6d62fcc1f"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "5e48adbab56f781460586178c6ed5ea019682cbdca9c50253b883c2beb8547c3"
    "nl"
  end
  language "pl" do
    sha256 "a4ea818f36d66e7acdd83f84ff3ae98a5a9d63f83fc98a509318c3f2e6835912"
    "pl"
  end
  language "pt" do
    sha256 "67f7b99188d516bc7e6d2b27ae79c79e1792fb5b930eac49972f28f0bd86936e"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "4c68901bdba645f972aa437cfc39e47f245a0b2d051071dc57e4861746fc16bb"
    "pt-BR"
  end
  language "ru" do
    sha256 "6153b6a8ea9d335ff9c0c24973ab9ba2f4a756499f0fa65f2214f888359b81f0"
    "ru"
  end
  language "uk" do
    sha256 "6e79792d26813d20f48c6fa1dc518b528d7f4bc4a923904497b272226a39764b"
    "uk"
  end
  language "zh-TW" do
    sha256 "8fc0dfac3a9784e621c59f700f702f71d0caa01631c22d552dd074a4b6c01e8a"
    "zh-TW"
  end
  language "zh" do
    sha256 "6444a73ed6dafc1fa38d1890fb641e2875d2ac744544c05c3897f05eb2f6b375"
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