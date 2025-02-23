cask "amneziavpn" do
  version "4.8.3.1"
  sha256 "f11e91087270e28749d26dca3e0cc389e5bf67d8d8b3ee42ad5a8bd9da6e020a"

  url "https:github.comamnezia-vpnamnezia-clientreleasesdownload#{version}AmneziaVPN_#{version}_macos.dmg",
      verified: "github.comamnezia-vpnamnezia-client"
  name "Amnezia VPN"
  desc "VPN client"
  homepage "https:amnezia.org"

  # Upstream tags GitHub release that can be pre-releases or betas,
  # so we need to check the download page for the latest stable version.
  # The website is hydrated with JavaScript, so we need to extract
  # the version from the JavaScript file.
  livecheck do
    url "https:amnezia.orgendownloads"
    regex(AmneziaVPN[._-]v?(\d+(?:\.\d+)+)[._-]macos\.dmgi)
    strategy :page_match do |page, regex|
      js_file = page[%r{src=["']?assets(index.+\.js)\??["' >]}i, 1]
      next if js_file.blank?

      version_page = Homebrew::Livecheck::Strategy.page_content("https:amnezia.orgassets#{js_file}")
      version_page[:content]&.scan(regex)&.map { |match| match[0] }
    end
  end

  depends_on macos: ">= :high_sierra"

  app "AmneziaVPN.app"

  uninstall launchctl: "AmneziaVPN-service",
            quit:      "AmneziaVPN",
            delete:    [
              "ApplicationsAmneziaVPN.app",
              "LibraryLaunchDaemonsAmneziaVPN.plist",
            ]

  zap trash: [
    "~LibraryCachesAmneziaVPN.ORG",
    "~LibraryPreferencesAmneziaVPN.plist",
    "~LibraryPreferencesorg.amneziavpn.AmneziaVPN.plist",
  ]

  caveats do
    requires_rosetta
  end
end