cask "tunnelblick" do
  version "3.8.8g,5779.3"
  sha256 "b3310a7435543c3047fd8500297fde7825f5ceb89e194f6adec0a3ee773d669d"

  url "https:github.comTunnelblickTunnelblickreleasesdownloadv#{version.csv.first}Tunnelblick_#{version.csv.first}_build_#{version.csv.second}.dmg",
      verified: "github.comTunnelblickTunnelblick"
  name "Tunnelblick"
  desc "Free and open-source OpenVPN client"
  homepage "https:www.tunnelblick.net"

  livecheck do
    url :url
    regex(Tunnelblick\s+v?(\d+(?:\.\d+)+[a-z]?)\s+\(build\s+(\d+(?:\.\d+)*)\)i)
    strategy :github_latest do |json, regex|
      match = json["name"]&.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Tunnelblick.app"

  uninstall_preflight do
    set_ownership "#{appdir}Tunnelblick.app"
  end

  uninstall launchctl: [
              "net.tunnelblick.tunnelblick.LaunchAtLogin",
              "net.tunnelblick.tunnelblick.tunnelblickd",
            ],
            quit:      "net.tunnelblick.tunnelblick",
            delete:    "LibraryApplication SupportTunnelblick"

  zap trash: [
    "~LibraryApplication SupportTunnelblick",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFileTunnelblick*",
    "~LibraryCachesnet.tunnelblick.tunnelblick",
    "~LibraryCookiesnet.tunnelblick.tunnelblick.binarycookies",
    "~LibraryHTTPStoragesnet.tunnelblick.tunnelblick",
    "~LibraryPreferencesnet.tunnelblick.tunnelblick.plist",
  ]

  caveats <<~EOS
    For security reasons, #{token} must be installed to Applications,
    and will request to be moved at launch.
  EOS
end