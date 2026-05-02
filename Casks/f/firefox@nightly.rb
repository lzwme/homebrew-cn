cask "firefox@nightly" do
  version "152.0a1,2026-05-01-21-12-38"

  language "ca" do
    sha256 "c96cae10dcc9e8e27a5c4c992b211bd104175dcf4fdbfbd8494eb59cb611f52d"
    "ca"
  end
  language "cs" do
    sha256 "803f9ce9ff6f518f901dd2af27acc6cb801a4e4db812a72ba4b8cd8337ccf50d"
    "cs"
  end
  language "de" do
    sha256 "6cda364fbde377fb6d6856b8b3f911bfd175912df115a758905b27aec8ab9cb3"
    "de"
  end
  language "en-CA" do
    sha256 "77748f1987125c718729430e26566f8821640ec41827ad9ffcc31b977de95d72"
    "en-CA"
  end
  language "en-GB" do
    sha256 "aa265f1e7fc4b6a7e3a148bed0edffc15ad98b6578d13b1665f95a347a3d7e23"
    "en-GB"
  end
  language "en", default: true do
    sha256 "6af7451f81624f33639680a77b08cfc0b76286774ac82229db46fd09cdad4f12"
    "en-US"
  end
  language "es" do
    sha256 "6a20746ecd0ebc543415fa433e11e6c7c136cc7969429ae918ec26aebb2cdad8"
    "es-ES"
  end
  language "fr" do
    sha256 "d1f13c5e5a8ad1dc2902b1e3fe3a8f38989985b2ac32cbaf7a7abce135a5b06c"
    "fr"
  end
  language "it" do
    sha256 "46aa094d934406ff0282fe1ae75ce6adbe2663df35cf1949a2bf1f8623faceff"
    "it"
  end
  language "ja" do
    sha256 "f3297318d941ba11bc91f43fd41559f5de94d464052c1471beaa1c06e6bcd235"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "6f1f10ac61b498ee2d5e455653f55e4c23b16bdaa1bb96df979cf67add898a9d"
    "ko"
  end
  language "nl" do
    sha256 "36a28db9801d65dd54994dd1ec2ff8a4e3e457a1ffc3327772ab717a933503b3"
    "nl"
  end
  language "pt-BR" do
    sha256 "31723554f0ef2f977192cdc539ed6a590a1a57d4ed76a27d90ffa6cc1488c57e"
    "pt-BR"
  end
  language "ru" do
    sha256 "86ba443a158b60d6f05c4948df4a74b7c83983af2799330d067f33d859525ef9"
    "ru"
  end
  language "uk" do
    sha256 "497e7a60fe313df2726d24aa55bf1bb15c8cab0d6c38836eafa14214445b4585"
    "uk"
  end
  language "zh-TW" do
    sha256 "3f67b52950e62bb921dc582b561fb69de534879c65caf2a30e4231e24a333bf8"
    "zh-TW"
  end
  language "zh" do
    sha256 "53686736c1a66bbe97c35209aedf4bfcbc2846197547e512edb42b8e71c9de04"
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