cask "thunderbird@daily" do
  version "150.0a1,2026-03-01-10-52-11"

  language "cs" do
    sha256 "60233d70ede5acf2944c35806e1ffdce5130099011675cc9eddd5105c25aa38e"
    "cs"
  end
  language "de" do
    sha256 "ace8d15d18960ab1684a2a218b8dd1367f426818d129a797bc2af1a541ae273c"
    "de"
  end
  language "en-GB" do
    sha256 "497b6af8071127b3ee9cfc9b9d6cc421d1494119b8191b43dec17292d80e133b"
    "en-GB"
  end
  language "en", default: true do
    sha256 "ddde15c37bcc1392f917cd13cff9437c54b3e065f0c37819aff5bb37c3c7811e"
    "en-US"
  end
  language "fr" do
    sha256 "a134747bda5b5b4cd1fbbbb1a0f0686a83320ab3f7c04ef1e3f908af0ac2069e"
    "fr"
  end
  language "gl" do
    sha256 "4c52fa58eb9336d160072f5d608317ef497992c81b4cc8071162b30a83ed311b"
    "gl"
  end
  language "it" do
    sha256 "edc56491754126c492e2433c3ced6edd38366811562630c72edde337d649f552"
    "it"
  end
  language "ja" do
    sha256 "3b5f0bef8bc61a80f3f68c297350eb401eca22fbd23c5f9675ad0ead1d8b80e3"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "49ef6c929b454b90991eb4d62cbfa8c0778f0309f46e8133776fefc9932e1f28"
    "nl"
  end
  language "pl" do
    sha256 "0f2a3996d8185bf08087042b3e520f61e939804eb8ab998d52aa7e5b98b69463"
    "pl"
  end
  language "pt" do
    sha256 "10a817e9c7a48ad85a72d8c143b996afe2224ee10190fc6cf8990b62eec0243f"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "3ddc552b863b93cad9ce252ff4c01e67e279c61192c541c8d7607e32b4d681e9"
    "pt-BR"
  end
  language "ru" do
    sha256 "e20795f1782321d68a3b43176e7c12b23db1c9fd1129aa384436142736674fbf"
    "ru"
  end
  language "uk" do
    sha256 "938ee8e9e0ea7d856cabcd4b50400319f06178e0583eb0da6d5077a747828198"
    "uk"
  end
  language "zh-TW" do
    sha256 "0a340c7b32b07935267f7b8ad9146f2b5c6c18d7b5d6564bc4218a2c1a0f46fd"
    "zh-TW"
  end
  language "zh" do
    sha256 "48922d3db8345b564abd9eefba48b0e496ba32d058b20a463b317520ef7dc7f2"
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