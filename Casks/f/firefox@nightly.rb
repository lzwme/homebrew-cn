cask "firefox@nightly" do
  version "150.0a1,2026-02-23-21-05-45"

  language "ca" do
    sha256 "6effeb74a0efba453655ceaace6ed541631caf80f0e92db13d84aa02065825e1"
    "ca"
  end
  language "cs" do
    sha256 "8ddbf061cf9b9380a237c81cc243be058cb328a289234fa7009f5dde39f778fc"
    "cs"
  end
  language "de" do
    sha256 "9085e93745e8b66a7ca606c39949f43b6e71bbb0c0dc5d6d54c93f5dc23a0908"
    "de"
  end
  language "en-CA" do
    sha256 "0b3c7b0b216e68ee2b2661925c1116845452c0f5ad9bf02dc8f9397e31eedc41"
    "en-CA"
  end
  language "en-GB" do
    sha256 "39a3c57399eb577abed910453c8ff9387a4386fb44509af24f3ceccf43750569"
    "en-GB"
  end
  language "en", default: true do
    sha256 "5c8d20397a5c5a08eaf9be3f3eaa87d504b9667403785727c1e1eaf4853911f7"
    "en-US"
  end
  language "es" do
    sha256 "2ea521d36a4546c923ab7d1ec807bd152ee5d892b4b0132778ca91838f63502e"
    "es-ES"
  end
  language "fr" do
    sha256 "ea0b1d6ec5142d414087a29e052e9a91b99a1e9c3fa3f534821ba9e1145761c9"
    "fr"
  end
  language "it" do
    sha256 "9ba70778acdedbd7bda7b4614bd45ed890c7e0f95d361a86996740e383501cc7"
    "it"
  end
  language "ja" do
    sha256 "63ccedc3b188a928e9f55a64fbd3c41450e01f8b8104d6ca3719acb92160107f"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "01367d1625f19c637d885051f0d8ea942b64803ca75d58ddd73b379de2591ba5"
    "ko"
  end
  language "nl" do
    sha256 "5210eaf10d63d6bdc3166e7330e676932b98bf79641af51ffe068371efc708d5"
    "nl"
  end
  language "pt-BR" do
    sha256 "9e313ec4964c92877e345010f2037ffbaa8a5395920f07222e89f77ccf279993"
    "pt-BR"
  end
  language "ru" do
    sha256 "1e06c2f0b715d917cebdb0d50f2e269cf75c8c27b8c808006e003544467c0eb6"
    "ru"
  end
  language "uk" do
    sha256 "d172197b86ce64ae590319088cb75e0a694a7164b4dac56c3beab6633843b34d"
    "uk"
  end
  language "zh-TW" do
    sha256 "568ed0b313a31c744f56c520328e850247118c8829025290de1f23f040092667"
    "zh-TW"
  end
  language "zh" do
    sha256 "9aad823607ee3f5eaa80c89cc5478c6aa06d1c2bf88aae4c7f3d274452b9f54e"
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