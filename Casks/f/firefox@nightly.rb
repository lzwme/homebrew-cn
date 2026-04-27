cask "firefox@nightly" do
  version "152.0a1,2026-04-26-21-18-50"

  language "ca" do
    sha256 "b09c4a57731404a9254d677f60fcefd837626431d1a7acf052f150b6ee41dbb5"
    "ca"
  end
  language "cs" do
    sha256 "5226a0eb99c763f8eae4b67df40752d0faf1d292c76b8670e493fe933b01ca29"
    "cs"
  end
  language "de" do
    sha256 "a7c68f4b9bdd5e2d5922b4bcb71f47102c6031ac56aed4785afa57cb27ec8fd0"
    "de"
  end
  language "en-CA" do
    sha256 "cd6530021c6d92b71379e7c2cae704aecda7eafc0d0d0157790d71a2fbc9a135"
    "en-CA"
  end
  language "en-GB" do
    sha256 "75336e7b8b073f27f55f39240cf8dea38d101a695539a5cdd0277c448bce477e"
    "en-GB"
  end
  language "en", default: true do
    sha256 "34cfd2fa6783fb14e7e8393ec2fd484b8b939b4d5a329f0c713c0a7d03970863"
    "en-US"
  end
  language "es" do
    sha256 "f5fb15bc185f25775af9012b53f8b31c62f843d31d1f24b93ade6077a0b878ca"
    "es-ES"
  end
  language "fr" do
    sha256 "801c148be743fe7da2fb1fd49bfb736c3318a3bc910032b18f800f949be8b4ee"
    "fr"
  end
  language "it" do
    sha256 "f33fd16ec802de3ea15c3b8056ba8485d518817f4cc70a61d97da5b089baf498"
    "it"
  end
  language "ja" do
    sha256 "9fa4eb777823c1f6ff0dfdc15052ae3c0e17e97403a23245704b552be77168f0"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "3a30c0b2478736ba7e8cb1162c6296ce5a5056a26b18dc9cc6722a89dec9f66f"
    "ko"
  end
  language "nl" do
    sha256 "311c2b16f7e17a4310b3082071dcc46efe20f01d2179f64f3ff92aa7790eac68"
    "nl"
  end
  language "pt-BR" do
    sha256 "f3f78ec0524eaec448f09ecaf38b6383349aa349a23a102ca04c2afa68f8f179"
    "pt-BR"
  end
  language "ru" do
    sha256 "6954261a0943a9f157de6c8dede33d755b4116a5862a70289e18a76fce898762"
    "ru"
  end
  language "uk" do
    sha256 "35096bc325e289014108d28b3bc0e191b54d7c58b141357c4445d76a63354e20"
    "uk"
  end
  language "zh-TW" do
    sha256 "0b45523cca9ae75787be583b9d62c44c7e630cb77d09a1e0bb5645248232e30c"
    "zh-TW"
  end
  language "zh" do
    sha256 "cd2cdeafb3d944dc4c1e695f16813dcb074aa6622589a701f9dccb58522be53e"
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