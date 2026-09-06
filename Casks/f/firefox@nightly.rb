cask "firefox@nightly" do
  version "157.0a1,2026-09-05-20-52-02"

  language "ca" do
    sha256 "88d915989f2a762e10e3c69108d673e8ae055c57f5eba9a874d898da440653e8"
    "ca"
  end
  language "cs" do
    sha256 "41326abe0cf5ff2a3584313e6fb88d483c535bbc5c41419b25c84f5c29205ccf"
    "cs"
  end
  language "de" do
    sha256 "9acea97c2d47a9b1492646b67e3597683bb21b69156f5438b75bbb78005685f2"
    "de"
  end
  language "en-CA" do
    sha256 "a7be1e5c626c2e422cd14879379a887c80558fa4b0bf37b2958cbdaf92ba347e"
    "en-CA"
  end
  language "en-GB" do
    sha256 "be5c110984ee5319fa5ccb21a435b9b3d54bf7da1d17293ab5764da4d1bd464e"
    "en-GB"
  end
  language "en", default: true do
    sha256 "ab694dc8a4d53e82bf4da679f19b495356de1e2b95f18f24bf5f97dec8542afb"
    "en-US"
  end
  language "es" do
    sha256 "640195383a3b2e0bfa644828b5c022eb003287868e53bb5a208d6c277071275a"
    "es-ES"
  end
  language "fr" do
    sha256 "df76b33ffcf47d52a25dc31d4b263a45c01a255ba3ad4dab54b536d863d2b275"
    "fr"
  end
  language "it" do
    sha256 "0d6be9e3a642264aa04a0133bb0bf4dde475636c2aa954a5198f07545029526d"
    "it"
  end
  language "ja" do
    sha256 "407ec6cb2f75d2a29c7c93a7687b2bc7faff58660701c3157fc56161a2ce2863"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "8924deda47b3bffd608834d1bf76310cbd92f1909259ffc089096149f62ecca2"
    "ko"
  end
  language "nl" do
    sha256 "0b76d9806d483a33be9f6d4b45406551bca917ac0e5fbac61464a77a77e488db"
    "nl"
  end
  language "pt-BR" do
    sha256 "b6877484659ec2948d714d4c96950961ca34be40daf01c81cc327cb32e4994c3"
    "pt-BR"
  end
  language "ru" do
    sha256 "04de962b3f3651120672eda4ad261031f1797fa7d327bb01cc3ada3b92fd5af5"
    "ru"
  end
  language "uk" do
    sha256 "b2c4a106df52da6847fbe33d6fe1c24068b339e6b2c3949bf97d831f5ff36b5f"
    "uk"
  end
  language "zh-TW" do
    sha256 "5810f1f4a3260174ffa9c335c33996973f3ae7032a2fbb376376cc8f7dd0f83b"
    "zh-TW"
  end
  language "zh" do
    sha256 "a51ad65571684190f07693c097f916a654c3864fd4670998fd168584716ca83d"
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
        "~/Library/Preferences/org.mozilla.nightly.plist",
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