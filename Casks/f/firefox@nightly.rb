cask "firefox@nightly" do
  version "152.0a1,2026-05-05-08-17-14"

  language "ca" do
    sha256 "38960603e1590dc0f04da92e093345005a14134005ee9053cd8cd7cc9627f650"
    "ca"
  end
  language "cs" do
    sha256 "26a4d98cfa16755879985cb5de017f8c36eb70ac3a3e05e4a22bf8a240f49c76"
    "cs"
  end
  language "de" do
    sha256 "9308578fa1baa00a8a639496c250296a6226d4bb0eb413ca6fb6629dbdd1d23e"
    "de"
  end
  language "en-CA" do
    sha256 "19396086d7437c51a4ff9330adcb1815881dd6ce4a9f3a3789590967413393a4"
    "en-CA"
  end
  language "en-GB" do
    sha256 "14c11ca7208832781eb75fb6a111873d4981995d00304ab14eb07d5ad46c77b7"
    "en-GB"
  end
  language "en", default: true do
    sha256 "19786ce561753cb2c9dd8b1b8201427063924ccab17c337068a784c737b23aa7"
    "en-US"
  end
  language "es" do
    sha256 "563aae8c20bba6fad5b476e8229108694aacc56f2b1dcc6e2da16fa5e8e620bb"
    "es-ES"
  end
  language "fr" do
    sha256 "54890b51cf1cc2cad40e389c03feed31cfa08dfe736ce1687e499bff99af4f97"
    "fr"
  end
  language "it" do
    sha256 "eed6145bffacde4c2b3b25bba4c945485bcade861af02faf413daf2d21d7641b"
    "it"
  end
  language "ja" do
    sha256 "fa0cd77fd66a3953bfbdaacaf1adaadf473d1c6532552d0246082167e6227055"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "910b6b66d540887711a49d5dc215b1e602578aa350cd65736e54077435f2f8da"
    "ko"
  end
  language "nl" do
    sha256 "d65dea3cad81af4ce2d07510f8fdc03564db9f53e31d6fdaf60f191468088ac5"
    "nl"
  end
  language "pt-BR" do
    sha256 "c66f43eb8d2f33ef0a38c9bc2f04c0bc8cf612751447b0b0944f54956a42c492"
    "pt-BR"
  end
  language "ru" do
    sha256 "342dec56a01a16c68bef7de202bf92743f8e5310cf047149d488c5920f2f798f"
    "ru"
  end
  language "uk" do
    sha256 "faa8fb60ba8c9b7d106fa4c25b335b762d25f4352b582ee0c51bacf1513748f2"
    "uk"
  end
  language "zh-TW" do
    sha256 "b7634936f02f33fd964712dc1338fbb101416d29d477d2bb56b535aeb2d5f159"
    "zh-TW"
  end
  language "zh" do
    sha256 "e84763efc36611d79b3ba6e071bbd7194b1cc2ea70c06d1a4e5acec33db93a14"
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