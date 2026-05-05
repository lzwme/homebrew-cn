cask "thunderbird@daily" do
  version "152.0a1,2026-05-04-06-49-41"

  language "cs" do
    sha256 "e9b565bee968742a97f6c778e172d6141a629023b30bb2b857c8d00025d14f73"
    "cs"
  end
  language "de" do
    sha256 "ccac6f0fe4a163bb4bbed845d10a4f5e3befa5eec49985774b4782eec635977b"
    "de"
  end
  language "en-GB" do
    sha256 "ab4fe391acad32fe99ddd22a8648ce71fb578b6833cc784983c3dec0184110e5"
    "en-GB"
  end
  language "en", default: true do
    sha256 "cca4ea8aa72ae0e8e8ed7c602f5ab0fc9bb3e62a1490171671b2fbcc1623a816"
    "en-US"
  end
  language "fr" do
    sha256 "7b65a33c9ff03922c294b7575c889e5bb548d1bcf568d3dfde3dd0a882450b07"
    "fr"
  end
  language "gl" do
    sha256 "d7c4a5f9e51e5f3d8696b96580e8b9d96c2d237cff1a5e72eb760d436b087043"
    "gl"
  end
  language "it" do
    sha256 "e81cd6236770616180913b87297cd6e1ddd6aded85b5b366bb64e66b319cf15a"
    "it"
  end
  language "ja" do
    sha256 "5df3a2bc57de4d0387b680b7d822f5279fee0441efa6a692d9276350bd7af029"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "c54153c7aed7a148199dfbc9787a2c13288b21fe3b1fce5b6d61c5bc962b9368"
    "nl"
  end
  language "pl" do
    sha256 "b7ef0235489749410982f81f9288754795adcaa1234c35ab97b1b09cf649795c"
    "pl"
  end
  language "pt" do
    sha256 "98145ae804e36ad23a679c434aba1a03935146aa1eb03f77118fdafa6b83ee9b"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "33608b8a67771c7a6b68560e49e52f07d03f580bb81685c8494c944e292532c8"
    "pt-BR"
  end
  language "ru" do
    sha256 "cbcb0696f2f78140d215df32080adc58e058731d1213d73ca38409f3129d9947"
    "ru"
  end
  language "uk" do
    sha256 "4254a4085b5968df4eac4cfb9db55b2069c455c33ec2666e4f0a4789eae21456"
    "uk"
  end
  language "zh-TW" do
    sha256 "3ed0dc54f2a817f9a1e106e2585684d8aa05e786f6a5e622ad317d3ed54b9f2b"
    "zh-TW"
  end
  language "zh" do
    sha256 "2eeba063ea87a5c477b7b26b88990c194244efe921c716a79804faa187c1082b"
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