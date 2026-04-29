cask "thunderbird@daily" do
  version "152.0a1,2026-04-28-10-06-32"

  language "cs" do
    sha256 "3667ac5d1e010f4b7d592f7077dd58b8d35d2ecfa794188a297b2e3571f9287f"
    "cs"
  end
  language "de" do
    sha256 "d13daee05287ac58da219c3b33a0558caa523efaebbd993168ebc5b5f7bd9257"
    "de"
  end
  language "en-GB" do
    sha256 "1521e6248435fc0aff8e7ea0d18bbbb885e6dd820904b7ef9f0c56a4ba5f0835"
    "en-GB"
  end
  language "en", default: true do
    sha256 "9b17c5ae0190696f5ae52a3725b303a70b4e756d316843f1d9312579cb631eca"
    "en-US"
  end
  language "fr" do
    sha256 "8a29a4c82c663a5d26d6131af492fa0ff06100d2902a8b076f6f7cfa600058b0"
    "fr"
  end
  language "gl" do
    sha256 "bdca23f5e9ee39c27eded859b6522b795372d8bde8088d35532220c5b033a315"
    "gl"
  end
  language "it" do
    sha256 "6a91532be878bfcf0ab358d96ec10aa95d02ce802740872f14c8cb61e9779910"
    "it"
  end
  language "ja" do
    sha256 "3a6e64e5c3f52285709038a160960727800b98de18e4d8f698fee7cb67d4c8c9"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "80fb14b3d2adebb2acb6fd37db671219e3c3813bf6829f5d5f632f0882676da5"
    "nl"
  end
  language "pl" do
    sha256 "0ea79bcfcad590d3315212a499a0b984fe6046c67c6dfa112f6abdcf8c06e831"
    "pl"
  end
  language "pt" do
    sha256 "a12eea80d217244d6283cb4f0753cceb1c7af33c7ebdc1cee7887bae15fc807b"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "e70be8b093abc00446271eaf7430697c1cc938bffb9b79cb7836fe885d0fc58a"
    "pt-BR"
  end
  language "ru" do
    sha256 "416d18dddce9defbf63feddd8d8a7276d1bf926c0e3c60ef321596f948b6fda4"
    "ru"
  end
  language "uk" do
    sha256 "5cef3c961629d1f9dddcd22d72a72aa32c13f504986701c3314bd96eb09bb5a6"
    "uk"
  end
  language "zh-TW" do
    sha256 "c41bf1b983fae0cda84126f3205d136ae919cc52d795aaadff1d11200f17828d"
    "zh-TW"
  end
  language "zh" do
    sha256 "e8174c0824c5384f6e3d038b5780e4da4f6c66f71feda6ac2a870d42d9e07e85"
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