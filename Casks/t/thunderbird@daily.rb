cask "thunderbird@daily" do
  version "150.0a1,2026-02-27-10-13-04"

  language "cs" do
    sha256 "2ff70727c23fa23b0f8875c021b932f878637392f016c2a5edbf12446fe391f9"
    "cs"
  end
  language "de" do
    sha256 "04b0d681b8a5f7b6923c2216bdd07dcb30dea29d3c43e2ace81f8342d8a327f5"
    "de"
  end
  language "en-GB" do
    sha256 "50794a112a54cb91c9fa24a459c3f84c9861c04752cfb3bc55d8c27ecd530f90"
    "en-GB"
  end
  language "en", default: true do
    sha256 "5db5cb9ead2ca375267501eb6232b81a5897ae65571246285029695735a2cdf5"
    "en-US"
  end
  language "fr" do
    sha256 "0c3e3621f9ea5a7aa977e21a7231793583295419c36086f7eb936238ac9e2a34"
    "fr"
  end
  language "gl" do
    sha256 "9f503a23e526c19f3dab422a2a74202137dcfbd467fc7dc17e7c4b4f39a87d3a"
    "gl"
  end
  language "it" do
    sha256 "4c435ac499f1af355fcc24461092a5b6eca50109f04ea969b2331de6e1531704"
    "it"
  end
  language "ja" do
    sha256 "e695ea5a043a6a1cdeae3fbd316cbb257b20f19fa23bd8ae968e1d0e947fc438"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "be7e157d888a4c4857d89d06ea5cf0d18bd692f278fd0e497ab1ef14a87593a4"
    "nl"
  end
  language "pl" do
    sha256 "46a911b820862bf6ac06d8db08fc8bd6694f466705ffcafd9229ae389b5de754"
    "pl"
  end
  language "pt" do
    sha256 "7f21f1288f7db6cf7a3b83bcabc353294ea4e728ebe41bb2a96f8d00a7c3e1a0"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "13bdebc51466d0bb41dd20a8de2298f72e6c16759bfb4b9e0312fe9e32c4ceff"
    "pt-BR"
  end
  language "ru" do
    sha256 "42ce07f851f65119c6383bebd3649516945d976c277d9fd4834a5fde27d62ba4"
    "ru"
  end
  language "uk" do
    sha256 "aa2130145011df27465d8e5d66e9afcc1f97d68b2bc6e868101c3177b056d22f"
    "uk"
  end
  language "zh-TW" do
    sha256 "367549f15e3bc09b68c327f88bcf4454679b2fdf175010919cc8d185b7cfa4e8"
    "zh-TW"
  end
  language "zh" do
    sha256 "ab3bad4d2173eeaffdf5c0425bd375e000eb3bdb694c82c03977f2f4a828869c"
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