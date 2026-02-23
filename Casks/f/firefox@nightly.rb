cask "firefox@nightly" do
  version "149.0a1,2026-02-22-09-57-48"

  language "ca" do
    sha256 "05762e8a2d943cbf89c8b49c03292e6f39f1110517057d6e1b0e65d883d49c27"
    "ca"
  end
  language "cs" do
    sha256 "80389bb514c4758df29fe37f1e0c4a8c3d96b9e5fceddde6f1a45294ee721d56"
    "cs"
  end
  language "de" do
    sha256 "e85e649d85117374585a665d1b2063f8ae016de64f9fbbac4e8e41b5e7964be1"
    "de"
  end
  language "en-CA" do
    sha256 "794db33c0ac80f4f4bc82ac0ef0fc7c2a69002b00275ee1fb5dc72fb75ad45e2"
    "en-CA"
  end
  language "en-GB" do
    sha256 "222ffdf83426eada30400e98d9bdd9dd2823b2e29d61437ba7b693a12d35caf8"
    "en-GB"
  end
  language "en", default: true do
    sha256 "d6be73e845db9dd4fce18eb54d7b24941b349ae401f5d3e738da9d1426619ae2"
    "en-US"
  end
  language "es" do
    sha256 "7396f8366a4509b247ad74a3a5ce4b36d45baaa10e1984dfe94a3fde11505632"
    "es-ES"
  end
  language "fr" do
    sha256 "20897a2cbdd10b709b017783613d6ce7dd6b9057ba545dee121e5d86e9f31610"
    "fr"
  end
  language "it" do
    sha256 "8d5b7d7f712a818741bcccfcc3694c191814e029ba41cb135fd21927e2e15c88"
    "it"
  end
  language "ja" do
    sha256 "1f692f3600e298b64e0d0176fd66f25055911a846ac2bd7651daef9a93a8da7d"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "647d3d9970e6c142c8d9c23bfe7cf36f923dc03390faedd6e5a45e8ce5aa78fe"
    "ko"
  end
  language "nl" do
    sha256 "713da3bd4f697c33aba07856256d042b0668a665b4aae1072661394f94a676ee"
    "nl"
  end
  language "pt-BR" do
    sha256 "8db8787ea55a08a232715f3161f80615d7707cddfe8f15a6e7bb2273c8b00747"
    "pt-BR"
  end
  language "ru" do
    sha256 "5b7dc353bb35ca1bf6f9ed67ac9a041d4fcce20d600d394dd4f3cb2360c6156f"
    "ru"
  end
  language "uk" do
    sha256 "fecef9e0a4772aed141298ff4247f8d57e8b9cf4ea6c39600b30cbf05af9e611"
    "uk"
  end
  language "zh-TW" do
    sha256 "38f0df574967c99b529fafdf13113df8255ae5247ec837e883ff5fd7c708b6c9"
    "zh-TW"
  end
  language "zh" do
    sha256 "a9375dce2156bab26c6bb220d40666c4e87edb191e418e26d1ac5983b7bdb003"
    "zh-CN"
  end

  url "https://ftp.mozilla.org/pub/firefox/nightly/#{version.csv.second.split("-").first}/#{version.csv.second.split("-").second}/#{version.csv.second}-mozilla-central#{"-l10n" if language != "en-US"}/firefox-#{version.csv.first}.#{language}.mac.dmg"
  name "Mozilla Firefox Nightly"
  desc "Web browser"
  homepage "https://www.mozilla.org/firefox/channel/desktop/#nightly"

  livecheck do
    url "https://product-details.mozilla.org/1.0/firefox_versions.json"
    regex(%r{/(\d+(?:[._-]\d+)+)[^/]*/firefox}i)
    strategy :json do |json, regex|
      version = json["FIREFOX_NIGHTLY"]
      next if version.blank?

      content = Homebrew::Livecheck::Strategy.page_content("https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-#{version}.en-US.mac.buildhub.json")
      next if content[:content].blank?

      build_json = Homebrew::Livecheck::Strategy::Json.parse_json(content[:content])
      build = build_json.dig("download", "url")&.[](regex, 1)
      next if build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true

  app "Firefox Nightly.app"

  zap trash: [
        "/Library/Logs/DiagnosticReports/firefox_*",
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.firefox.sfl*",
        "~/Library/Application Support/CrashReporter/firefox_*",
        "~/Library/Application Support/Firefox",
        "~/Library/Caches/Firefox",
        "~/Library/Caches/Mozilla/updates/Applications/Firefox",
        "~/Library/Caches/org.mozilla.firefox",
        "~/Library/Preferences/org.mozilla.firefox.plist",
        "~/Library/Saved Application State/org.mozilla.firefox.savedState",
        "~/Library/WebKit/org.mozilla.firefox",
      ],
      rmdir: [
        "~/Library/Application Support/Mozilla", #  May also contain non-Firefox data
        "~/Library/Caches/Mozilla",
        "~/Library/Caches/Mozilla/updates",
        "~/Library/Caches/Mozilla/updates/Applications",
      ]
end