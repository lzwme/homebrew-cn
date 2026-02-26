cask "thunderbird@daily" do
  version "150.0a1,2026-02-25-10-58-53"

  language "cs" do
    sha256 "1688aec5265e840f58197c92f74f1f61ac21dd64a3dd3f2eaa2e99fe8fc79aba"
    "cs"
  end
  language "de" do
    sha256 "ad5c9295aa033ddce3139ec8f35f4eb5f6ce61f7717f7d09e494f2a751ba9a89"
    "de"
  end
  language "en-GB" do
    sha256 "6381d416756ae7271fae383dff44b30284f1f4ead3146b266462f03297990b5e"
    "en-GB"
  end
  language "en", default: true do
    sha256 "556de00c00aaf87091a8b307a5354f776be0d3700261fd5a0293bc256ad13842"
    "en-US"
  end
  language "fr" do
    sha256 "95fbb822de5436436a8a8eb620b33b289f16917ff61bacc93aaafb2db03e4646"
    "fr"
  end
  language "gl" do
    sha256 "47fee7358d3c66053fcb66c01742a9c376e1fb233e03254b6a0f01fd54856c48"
    "gl"
  end
  language "it" do
    sha256 "4a9097453d9e49f3909c1f12061274cdf2f605830165c3f52b86df7660f98658"
    "it"
  end
  language "ja" do
    sha256 "3c29a805ddd71f8b566e554ef3f21d45457367c677940a48f41abc78222fd298"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "25b7c8daae13baf971820fd7b928cd7f2a27e3adad6b1df430b90ca16aa5484d"
    "nl"
  end
  language "pl" do
    sha256 "bbecc170114220cd158ec9e87e37fe471be83cd22fd34bee79eb3f3212e6cd82"
    "pl"
  end
  language "pt" do
    sha256 "0d50940e13fb7ca611549c509f91f7f5691eabcd9d2f5b58caea3c4893bbac63"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "aa7d706618e88b0a525bb8d78518ab2d2056d85c1b8240d155dbfe05c2ecb822"
    "pt-BR"
  end
  language "ru" do
    sha256 "d97cb691009ab26a432ce3ba15d7db73ef9f55beb523fbd1e0aff50e09ce1147"
    "ru"
  end
  language "uk" do
    sha256 "be2ea2fe376e63cb0517cefb332cd20e9bd13420e7381860f6af7ddfb13e18cc"
    "uk"
  end
  language "zh-TW" do
    sha256 "0341808cc6224fca4bded973ad6166d03065e6a069d01682f97c278154186285"
    "zh-TW"
  end
  language "zh" do
    sha256 "0ef058ed44274cdfa83936b2896baa8545df650ff460c80b69c2d8d2874b7cc5"
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