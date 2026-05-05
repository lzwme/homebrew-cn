cask "firefox@nightly" do
  version "152.0a1,2026-05-04-20-22-20"

  language "ca" do
    sha256 "4a2aea143e7e81f9468d83dafbd3ae2cd28171918afc35ae5028f1ffb47450f6"
    "ca"
  end
  language "cs" do
    sha256 "94a0548f1080861e1f403f675106118ad346ece10f497a009a03e8eba6ba6d41"
    "cs"
  end
  language "de" do
    sha256 "66e10da983850fc2b1f03de476a6b5a3bc442696de263d47899da2daa69a6972"
    "de"
  end
  language "en-CA" do
    sha256 "b94809c8cd06de2b032c14050d4a5cdd318ca874a8ec4ffc2b774d0346c32b49"
    "en-CA"
  end
  language "en-GB" do
    sha256 "42e6789978f4a71fd35ce28295250236dfd431346094db52633ade2ef27148e6"
    "en-GB"
  end
  language "en", default: true do
    sha256 "d3c1f500d0aa0cc2805bda1e7e49b6e86aa860babe0e3b993fbce23ee15c979c"
    "en-US"
  end
  language "es" do
    sha256 "b6f61fbba08d4c46894c1f07320ec012a575f5229b9180cf3fc1f2056db610a9"
    "es-ES"
  end
  language "fr" do
    sha256 "4ee915ecda83eff3e608619d3e6b807ad56916a730066ab94086a1c301963140"
    "fr"
  end
  language "it" do
    sha256 "6bcf442a31c996f4f11efc54da80b48ec74b3efe1b48675868d07fadb0a89717"
    "it"
  end
  language "ja" do
    sha256 "8bf1dfbe93b17f0bfa4cacccd53fbe6e1874b655f383662e1ed4c7c8005523f1"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "1649360e1ecc7ab77bb75281c09a226d5d8da937a50f4de59eddf216be14dd79"
    "ko"
  end
  language "nl" do
    sha256 "8699edbe54d37730f554e116c6f0c7f09664178c238b4668bc7abe718ae25c6e"
    "nl"
  end
  language "pt-BR" do
    sha256 "fe6db60ce8bae3a17988f32669f3ccd7e94a62e1e6e6017a81af9d3171f1faca"
    "pt-BR"
  end
  language "ru" do
    sha256 "0a2a51cb71ee785a3143909e6b7065f34455b835c1ccee0194405789906631a0"
    "ru"
  end
  language "uk" do
    sha256 "c3e035d3286206d4184e67e531b2432f598176b7d3bdde214eab3ab1ae2ec2aa"
    "uk"
  end
  language "zh-TW" do
    sha256 "4300ffbf6228b4534c099d367e69837f95fa78d63d4836ab8236386ca22ddc6a"
    "zh-TW"
  end
  language "zh" do
    sha256 "1a9cb7d1f99b193d577e525362134ff6b1e895606090468ee2f1db26e5f1e8aa"
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