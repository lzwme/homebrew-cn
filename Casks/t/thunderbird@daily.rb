cask "thunderbird@daily" do
  version "150.0a1,2026-02-24-10-32-06"

  language "cs" do
    sha256 "190b653f6ff373060b8e86ab74f75581216c0ee11488ed5918808170c1cb1b77"
    "cs"
  end
  language "de" do
    sha256 "7989456ac2339879f07990dafe929bc95d2633edae431de73a3f4e2bde320855"
    "de"
  end
  language "en-GB" do
    sha256 "684c06c4a8a7833f9f762b700c85d2884cbebba7b86018a12a19bf94835bb7b8"
    "en-GB"
  end
  language "en", default: true do
    sha256 "36f5a2f0ac6d0b46a8c6bc4f779d0eec124f971333d53118ee6241155dde1b5d"
    "en-US"
  end
  language "fr" do
    sha256 "4dd38bad1b0d5f3512bbc7c2d7b2bae11b680396d762df2cac24e74446759bbf"
    "fr"
  end
  language "gl" do
    sha256 "418cae7d4bd99551e654634fa3c9a20ffab2af22dfd463d118927ba4fef80ba2"
    "gl"
  end
  language "it" do
    sha256 "163124f76c85b61073e0f002ea8397b1ebaef7d606e56a875c73b2a651284fa3"
    "it"
  end
  language "ja" do
    sha256 "38e5c8672425e9cc6bace2cd4e7b93a098b8c53b479863be08868210758945b1"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "f784c8160e098687f7c0acdc9ce2143360d501c0a9417ed8bc151c6821ffb98e"
    "nl"
  end
  language "pl" do
    sha256 "389d2b585bb5ba73ac96d37640489e235a92bd2acd2db1f6c007cc8428b71c29"
    "pl"
  end
  language "pt" do
    sha256 "fd408f0f4ddad7a7570a2a686017cc2b6fc766941a5ecb6bf68f6fa29cc7c7ce"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "3fda26af7c64096119086e1a6ccd792c27ea2191ad46f20857fdc716a5c5819a"
    "pt-BR"
  end
  language "ru" do
    sha256 "fb84ce1e513c471dcf9a20c4f38e56cb192e6b1587fc9a94aeb59759ad0a68eb"
    "ru"
  end
  language "uk" do
    sha256 "76a81d7b51046ce761a5abf1cc3efa60094b7a2fb75aac231c5cd6b59dc41607"
    "uk"
  end
  language "zh-TW" do
    sha256 "35bd6cbf6e5feaa2de41e166c50cfcd87d97bdc18413f12b0c4b1f22d8df0351"
    "zh-TW"
  end
  language "zh" do
    sha256 "b537e5cf17da674ceae3a081e1559cced0023414bc40c962a3fa32768a3fb4f8"
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