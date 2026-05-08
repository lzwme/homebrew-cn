cask "firefox@nightly" do
  version "152.0a1,2026-05-07-08-37-59"

  language "ca" do
    sha256 "0be3068776fc5d5d71dc585a3d388cf30f57f69ed6a600060c88ac5e852cb5ab"
    "ca"
  end
  language "cs" do
    sha256 "a69719ea6264df8e4877c99ad3671218c61859c68634b0f43373c94796ca2863"
    "cs"
  end
  language "de" do
    sha256 "232b8ceb9f52da1815397d0de4c32d1fbe29eb8346fda0508203d6601b6821db"
    "de"
  end
  language "en-CA" do
    sha256 "7f37066211f3f187c106dcb19045335c45bbbdf95ced94a951c49ee4cf7cb965"
    "en-CA"
  end
  language "en-GB" do
    sha256 "91ffd6b649beeb49051774b4702fee256b75887c3284b470717489ba96653063"
    "en-GB"
  end
  language "en", default: true do
    sha256 "d539b38c22ddb62589a7f64fca10005a9399de002809b21b495944fa5a014edf"
    "en-US"
  end
  language "es" do
    sha256 "60079a31c59099649fe0d0f613b1e5104e2135a48f3695711118dfd9697bd5c7"
    "es-ES"
  end
  language "fr" do
    sha256 "af510e96137ac4d991e67be37a2203dac05b10283320b7fce92ce8f0ba8d051e"
    "fr"
  end
  language "it" do
    sha256 "afae2b4ca5d40f25a99429ddb8840804573b9591b9219235e27c5c7528bb71bb"
    "it"
  end
  language "ja" do
    sha256 "d18e1df9532e3bf4ced14605c085865ea2209c827f1c6f41f7b1b9d6d86699aa"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "bdba2a29c52f34edbb2c84d213cf0c46561bc615a94dee91380c310c83b04aaa"
    "ko"
  end
  language "nl" do
    sha256 "2be9c89b5866f12180b28859e94fa18d54fdf7a438f474e347525a45c9ead91a"
    "nl"
  end
  language "pt-BR" do
    sha256 "36a4607aeb67a1c4dc7151d2325a3ec8830eba90ec03cb28eaefc6daf9e2e65a"
    "pt-BR"
  end
  language "ru" do
    sha256 "016731c5d4e1420ec941e00827ae27bc2dc8f16443b1fe91cb130725c9eb387e"
    "ru"
  end
  language "uk" do
    sha256 "e906662198ad07a830f7c6057d7d1621403bc1873100b00582c42ae39a3a7674"
    "uk"
  end
  language "zh-TW" do
    sha256 "85dd34676c3127eb629ddc369c1997b9445bc1c6326208489764558130d68b0b"
    "zh-TW"
  end
  language "zh" do
    sha256 "0207070d1d0334353f6ce75129ce47aa6affeeb14325c550f46270daab4accdb"
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
  depends_on :macos

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