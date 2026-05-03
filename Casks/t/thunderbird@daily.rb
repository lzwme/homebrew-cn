cask "thunderbird@daily" do
  version "152.0a1,2026-05-02-09-57-16"

  language "cs" do
    sha256 "73f0944b50b1c3b4e7057a4a9b9b503591f3426cf8c12f727294e690e1f0d536"
    "cs"
  end
  language "de" do
    sha256 "eef37851f615956bf4fb03d4f138c266ab76c014b3d7d42e872b756e0f215ddc"
    "de"
  end
  language "en-GB" do
    sha256 "c5f86b093023bbf34c5832f644038ad1ad4b26ad2910608a0ede990899488704"
    "en-GB"
  end
  language "en", default: true do
    sha256 "07aab2fad34c4576e5fb11a2823df2b9c265c6f7ff4a94e481e0011eaf926120"
    "en-US"
  end
  language "fr" do
    sha256 "7c67ae6bbabd32d6d84107a37aca104e9d3b5749254b596725f9d694b4e2d0fb"
    "fr"
  end
  language "gl" do
    sha256 "09557929d8e9dc1c9b1a810c18c02798091dc6aaa7519160d12bcfdc1eec87de"
    "gl"
  end
  language "it" do
    sha256 "94fa4dfd7ea05020146144aa101eb3cbd8f123129e786a8fc054e42246f2c582"
    "it"
  end
  language "ja" do
    sha256 "ed331f575d0769d5d473bf992ee7630fda248442d7556b16e5d5d01810adb9f9"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "cd17197d525b8d34df93e1cc6f1406cb6f6a27b4027c9ecae03d254fe3459690"
    "nl"
  end
  language "pl" do
    sha256 "e933110bd4f44d58f7ba81dedbfe4d13aa250e7c621acc1e6a9261c32d654a39"
    "pl"
  end
  language "pt" do
    sha256 "123541c476205f383aafd937227a1792d91686a1b70769f9668ad6ef250fe780"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "e980935f6147acf18313d5964c7cfd3fcab9f7e26868035c8a4a7c75915364f2"
    "pt-BR"
  end
  language "ru" do
    sha256 "7028c320ed9e01a71587168ddf6ff25e3fd1d80095c6c857100f2b1cf8274564"
    "ru"
  end
  language "uk" do
    sha256 "e2f93e67b456f3cf57cce04569327f26753cd63102b0afca8c5e724aeb83ceb5"
    "uk"
  end
  language "zh-TW" do
    sha256 "15d98262fd4a1636c5a42388eee840a639d9c5bc2d27aa9e2dcce849386dd203"
    "zh-TW"
  end
  language "zh" do
    sha256 "810585ce7b85ebf81e1c52dd3f8f0acba6480e4844c6275d88a236423ade2caf"
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