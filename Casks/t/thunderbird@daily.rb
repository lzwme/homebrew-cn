cask "thunderbird@daily" do
  version "152.0a1,2026-05-01-09-57-27"

  language "cs" do
    sha256 "e5e07c7089cbe6a4d6076fa9ab1b3ca4c6f8242482e4e9559e7f4cad321d62d2"
    "cs"
  end
  language "de" do
    sha256 "106f3d7c2e5e323d4e7ba45d3c8fc17cb90bf670ba129bbca76751431c1da2e6"
    "de"
  end
  language "en-GB" do
    sha256 "29ab9fb6e91e3c2cec71bb40381ae3f5ff99a4dbbe8d13faf869d795ef677395"
    "en-GB"
  end
  language "en", default: true do
    sha256 "28c1dc298f450904773b3344b82f9d1c7b41cf1f6bca402fb226c7874117bc32"
    "en-US"
  end
  language "fr" do
    sha256 "b23209af3645dc044f36d21d6b15a852c3f4f8046c3c416f4bc4cb59b6abd478"
    "fr"
  end
  language "gl" do
    sha256 "6b4336962656a5b30b9ef1fe0ec3cabcea1c0e9ccfe938ffdd7c7045fc5c028d"
    "gl"
  end
  language "it" do
    sha256 "c0981dde721fd6f6c52fefdb1c6b37aaa8fdf430da7574543f87a32e163f8216"
    "it"
  end
  language "ja" do
    sha256 "ee1550149a301ba772d93ec539f85684795ef81256758ce6b48eb88e1d7fe1cc"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "8f51834b422331952b95f2af81fd701295176e327f9e525c4371c28fb9bd1adf"
    "nl"
  end
  language "pl" do
    sha256 "df7a9bab17832cf76b158ee88e326e6bc94ff0f27aa240684cf971839d02b58e"
    "pl"
  end
  language "pt" do
    sha256 "90ab635ca8f2e18886569b96a42bd320c50b67fcd79423e513f3d3a96b6c8ae5"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "042bd23b171cb3bd376ba322659828f0d98bafdb8db2d7efb1ead229597eaaa9"
    "pt-BR"
  end
  language "ru" do
    sha256 "4c24787da5f0e36fd2b4b4761fb93ce91d02045c45a1fe216f6e96621b7b9387"
    "ru"
  end
  language "uk" do
    sha256 "84ca121413861bbc134127997ad063822080122df5dfb434d35653d1ca730e88"
    "uk"
  end
  language "zh-TW" do
    sha256 "132b15ee320867a731b4edf8c69e8ff07997a07727e8ea7e9496b1ad1498fcb1"
    "zh-TW"
  end
  language "zh" do
    sha256 "153c51bc949f45813cc61b2187d9e98befbda0d9823bb92feed0db56a4c0f172"
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