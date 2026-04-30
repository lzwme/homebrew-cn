cask "thunderbird@daily" do
  version "152.0a1,2026-04-29-09-51-29"

  language "cs" do
    sha256 "cf1cd71b95792f364d9bf2a2a45590519607886e427a626b5f6df7e052536883"
    "cs"
  end
  language "de" do
    sha256 "35c72a7dd73a25c902e40737fc6c9e98d0f5d64a4f84eeda63cd44e06dfec30e"
    "de"
  end
  language "en-GB" do
    sha256 "b80a7a2338abeaaed5387111c115f4400c921d32b00666c8e4ba5c7e299527c5"
    "en-GB"
  end
  language "en", default: true do
    sha256 "e40764bec9de260ad922bef12db2238810f65b0c9d63f32e88fdc07de20d4eee"
    "en-US"
  end
  language "fr" do
    sha256 "4cac3fa79b6339637c66dbe72d94d669b9388c9ac2a0d51dbee70b6c38d8bf27"
    "fr"
  end
  language "gl" do
    sha256 "4e56da2157ec63e21a60978283c6844cf07fae66fbc7d00b9a2a15fc5b5dec79"
    "gl"
  end
  language "it" do
    sha256 "7d2b67d297fd0889ae6551236df426c37cc0be2477eb8e8bb8f947525deb3a68"
    "it"
  end
  language "ja" do
    sha256 "19556e2ba4e996c2b54afe91342e98bf87b12699d97f1bbb6d6059f4a07043d8"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "18257a2c59826a1496da6bbd828b8ca8bc49d71a10cd3cedac04f2de43d162ca"
    "nl"
  end
  language "pl" do
    sha256 "1c918e06059566366d6b36a20e5011758282d3ab821dff09c6f37591d20d25fa"
    "pl"
  end
  language "pt" do
    sha256 "f4704effc4af7856f32f55df3c5caa2256a6486bc589b22a6e60c55cda0e0dd5"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "a1ff61c5e41cb009b922983113753152b6d92f8bc6655c09478549f187560c87"
    "pt-BR"
  end
  language "ru" do
    sha256 "e8fa9a2234d07320915010fa6ba80bfc3690826609acabf6574d6046acebc3da"
    "ru"
  end
  language "uk" do
    sha256 "24e9f118f51ace21b4244c2754ffdcacd1bcfcf461ef8c4b4b072ed111be38c3"
    "uk"
  end
  language "zh-TW" do
    sha256 "11dc111e8a4f59cf87f993aa233413348ea6dbf723fc279b74c4644708af2854"
    "zh-TW"
  end
  language "zh" do
    sha256 "91a9ea05fb2fa1ea4af63e57ec5915c53de4799cbfed93587e6c8ad5234b6a5b"
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