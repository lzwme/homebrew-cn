cask "firefox@nightly" do
  version "152.0a1,2026-05-03-20-15-28"

  language "ca" do
    sha256 "9d1fc2144a67afc22d9c7178b9241b04bdb828bab3ca15f6e1a43cad7d461054"
    "ca"
  end
  language "cs" do
    sha256 "13c6c7d2dd9d1596134de8e82207affc54ba95ff0f0ef9d7ae0428ffe2c0aa71"
    "cs"
  end
  language "de" do
    sha256 "db0f4024063c9388f644624169302e53a77ba12fa532eae59ef4ce16d72f89da"
    "de"
  end
  language "en-CA" do
    sha256 "fff302847880291ed1b47e5622568cabad38ddecff474e6617fa13dae9d5acf7"
    "en-CA"
  end
  language "en-GB" do
    sha256 "d66bf5f1efc58f0b1d6f89e07b3fa94366c31ae4250d820d5d8f7474dc9c6e1e"
    "en-GB"
  end
  language "en", default: true do
    sha256 "fc8ed6d1f66407813edf85e58bc3e0b4ef3e562ae7ce257b65bc9f8109c0c509"
    "en-US"
  end
  language "es" do
    sha256 "89475ed5ab1d8a1bea3cfa72ab692a20064f16399eecf098afd126bec0a524dc"
    "es-ES"
  end
  language "fr" do
    sha256 "44e49d5d7bf98fdfa1300817a59eef475275bf8adea3b90c00d8e41ae162992a"
    "fr"
  end
  language "it" do
    sha256 "4d20012d1c9c426fe7f50351438d2718edbef0ad74bf3d4b3250ab03d32e5df7"
    "it"
  end
  language "ja" do
    sha256 "df37373ce31deb4cb088ee629d5705cd914ef54c28ae82c42a0574b541b905cd"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "0ba1394ee862543625eaffed1661c9e456ee074f29a5675e5e3fc4dc592ce25f"
    "ko"
  end
  language "nl" do
    sha256 "74fcc8c386fd5a3c50426d925643c8b44ec96bcc241f972345411efe714e20fc"
    "nl"
  end
  language "pt-BR" do
    sha256 "d881ba79bcbd86ed72296d94b88101b297b9a1d4d669b2f84ad85bc5e1baadc6"
    "pt-BR"
  end
  language "ru" do
    sha256 "d10f70c32b10dbb914c2ff1cd875eafd710532d66c426a660c14a4ed4cd85451"
    "ru"
  end
  language "uk" do
    sha256 "568b2487bebab6a499b56d9e9711308a4762c2807afba6ca8d7ac83529e67282"
    "uk"
  end
  language "zh-TW" do
    sha256 "e32732c8281957bfc634fbffd313f2eb7484b7b44026d19d05fe891d89037712"
    "zh-TW"
  end
  language "zh" do
    sha256 "3272bdea9a282b2367b5a7db10da80725e7bc8b4e216f6e4ad5d2826cc99dc9f"
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