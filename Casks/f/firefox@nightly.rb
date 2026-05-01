cask "firefox@nightly" do
  version "152.0a1,2026-04-30-09-28-21"

  language "ca" do
    sha256 "d9c868f21e08c8b6cd4233f1bb6201306d23c82ff6552d44ea54fc85807151af"
    "ca"
  end
  language "cs" do
    sha256 "0e5203814fa75a0faf6087621df6d5924df2f3c97ea93cc9f216f5f88d6e3cec"
    "cs"
  end
  language "de" do
    sha256 "d4df5c8033cf16359767bc305352226607cca5f3ee0bbf418a1f2ecd0ba5a3c2"
    "de"
  end
  language "en-CA" do
    sha256 "0798ae1261ea519d95e1887afbbaeec4ded59173487c3873abbbb43db34238fd"
    "en-CA"
  end
  language "en-GB" do
    sha256 "f6a5975bc546eb16725a19799730c1044eed5601d88bdfce299873fa38a29e3b"
    "en-GB"
  end
  language "en", default: true do
    sha256 "c0bcab251b5aff634e18b7a26374a01423cde1c2ca6fc6dbdb60ca07f1aacba3"
    "en-US"
  end
  language "es" do
    sha256 "8c8109cb2660468ab083d33668d399cc8ca33d1f84c91ce8707f48f9bc5a3b38"
    "es-ES"
  end
  language "fr" do
    sha256 "1913675fc8fc600acf9d8cd847839141eec6a99ef2e84bbe5042d54bdcfe8199"
    "fr"
  end
  language "it" do
    sha256 "7124684f191b246d691d2734f08f4f3925249134c46d0d5fac3385c32f6cfbe3"
    "it"
  end
  language "ja" do
    sha256 "a76565715426049565dd3171245686fb7d6adc487a90c56645582dc1782c0236"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "7aebb4a79378c443ed15707098269c96baf968b1075214362cc0c87549fe80dc"
    "ko"
  end
  language "nl" do
    sha256 "2bc97f85b3d5696f486a80f40a987151ace56ad7509cc132ab7e96e685f0de3b"
    "nl"
  end
  language "pt-BR" do
    sha256 "3cba042a9bfd5bb23add6d35a9b48b379c76d76226beef0948985c94d5411e3d"
    "pt-BR"
  end
  language "ru" do
    sha256 "de673eab0888a065746279caab4bdc551931861587307ed1e069d5d6b9f0fb36"
    "ru"
  end
  language "uk" do
    sha256 "242b79ba7b1e1ea3cc248f53c0900d5fa5d094d1932e37ee0f6cbf06238d1474"
    "uk"
  end
  language "zh-TW" do
    sha256 "a52d848f24e60922b4c837ee005d1bc38e53f62017b708f1d946100276c1bf6b"
    "zh-TW"
  end
  language "zh" do
    sha256 "09e958513942b523ed138e1d7408b63e5c32d87b7e660783920ac2f314550c53"
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