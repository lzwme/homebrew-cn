cask "thunderbird@daily" do
  version "152.0a1,2026-04-27-09-14-54"

  language "cs" do
    sha256 "1f467c9d080f8659c5e3f2aca3f05565b50964c0440f957e955c1d0be4c4dc4a"
    "cs"
  end
  language "de" do
    sha256 "ef0b020c59bf7a0571ac8de2596b4b94675cb6854dcf7f9375791a883d574a36"
    "de"
  end
  language "en-GB" do
    sha256 "ae9002f92d1f2e19d1c428d45ba6770803e0b6e1b65cadd8e58a6d43dd07ca93"
    "en-GB"
  end
  language "en", default: true do
    sha256 "fe1e49e74fa8281e1ef3d48860cc48259558e7331d59194a47c88292699f50c8"
    "en-US"
  end
  language "fr" do
    sha256 "c7040d3b559d9c69037e9407d9dbb062b694f4f6933c87f8b5b63fd7ec29855b"
    "fr"
  end
  language "gl" do
    sha256 "ae87aa68333a715ecebe9aaf96000ad4635b3162504fa8fc54e7398aaf3a320a"
    "gl"
  end
  language "it" do
    sha256 "0eee10c905820871698e5908bef467841a2c3ae54c0ead818badfe8bc7df8471"
    "it"
  end
  language "ja" do
    sha256 "eea63e1de62c789c912a7c859389fc889640ae519f1fe4ea2ff2342d6c32b880"
    "ja-JP-mac"
  end
  language "nl" do
    sha256 "5b394c26430bbb69f55d905c844f7376a3ec4aba372e0cae5dcd349de08b8c4e"
    "nl"
  end
  language "pl" do
    sha256 "a606338b30702306f62ded28ae3cca389b157f0f8c57da06b58ac4dcb518ed83"
    "pl"
  end
  language "pt" do
    sha256 "198a5b1cea19c46b20cb1ff5592b83b292e837f875e7c2ab873529ae35db0c0a"
    "pt-PT"
  end
  language "pt-BR" do
    sha256 "d6668ab26f3e2740825bdfd4ac2f5ecb46668e9500d7996e42a9ba8b32259b2f"
    "pt-BR"
  end
  language "ru" do
    sha256 "49bfcb60cda57bbc023268a9bb451814bb0297dc1d0a85cf5a08a6afdf2f0598"
    "ru"
  end
  language "uk" do
    sha256 "7bf6cdba4961b3e0b1f03a9e9803f120330c65aba4fd5be13d3f46597e1a2954"
    "uk"
  end
  language "zh-TW" do
    sha256 "750162cc070f12bf51219cf91ce18f959d1f849be44afc2e76b32e8bb18b5be3"
    "zh-TW"
  end
  language "zh" do
    sha256 "b820dfa9c6983e4d9dacce03e3512c6344365b45cbf7b7dbf03c249064a8f14c"
    "zh-CN"
  end

  url "https://ftp.mozilla.org/pub/thunderbird/nightly/#{version.csv.second.split("-").first}/#{version.csv.second.split("-").second}/#{version.csv.second}-comm-central#{"-l10n" if language != "en-US"}/thunderbird-#{version.csv.first}.#{language}.mac.dmg",
      verified: "ftp.mozilla.org/"
  name "Mozilla Thunderbird Daily"
  desc "Customizable email client"
  homepage "https://www.thunderbird.net/#{language}/download/daily/"

  livecheck do
    url "https://product-details.mozilla.org/1.0/thunderbird_versions.json"
    regex(%r{/(\d+(?:[._-]\d+)+)[^/]*/thunderbird}i)
    strategy :json do |json, regex|
      version = json["LATEST_THUNDERBIRD_NIGHTLY_VERSION"]
      next if version.blank?

      content = Homebrew::Livecheck::Strategy.page_content("https://ftp.mozilla.org/pub/thunderbird/nightly/latest-comm-central/thunderbird-#{version}.en-US.mac.buildhub.json")
      next if content[:content].blank?

      build_json = Homebrew::Livecheck::Strategy::Json.parse_json(content[:content])
      build = build_json.dig("download", "url")&.[](regex, 1)
      next if build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true
  depends_on :macos

  app "Thunderbird Daily.app"

  zap trash: [
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.thunderbird*.sfl*",
        "~/Library/Caches/Mozilla/updates/Applications/Thunderbird*",
        "~/Library/Caches/Thunderbird",
        "~/Library/Preferences/org.mozilla.thunderbird*.plist",
        "~/Library/Saved Application State/org.mozilla.thunderbird*.savedState",
        "~/Library/Thunderbird",
      ],
      rmdir: "~/Library/Caches/Mozilla"
end