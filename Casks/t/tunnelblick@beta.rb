cask "tunnelblick@beta" do
  version "6.0beta06,6100"
  sha256 "b62d2fe025622a5328aec87fad74e6b9aecb3820e33f3f5d048a61c2ee56009a"

  url "https:github.comTunnelblickTunnelblickreleasesdownloadv#{version.csv.first}Tunnelblick_#{version.csv.first}_build_#{version.csv.second}.dmg",
      verified: "github.comTunnelblickTunnelblick"
  name "Tunnelblick"
  desc "Free and open source graphic user interface for OpenVPN"
  homepage "https:www.tunnelblick.net"

  livecheck do
    url :url
    regex(^Tunnelblick[._-]v?(\d+(?:\.\d+)+[._-]?beta\d+[a-z]?)[._-]build[._-](\d+)\.(?:dmg|pkg)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          "#{match[1]},#{match[2]}"
        end
      end.flatten
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
            quit:      "net.tunnelblick.tunnelblick"

  zap trash: [
    "LibraryApplication SupportTunnelblick",
    "~LibraryApplication SupportTunnelblick",
    "~LibraryCachescom.apple.helpdSDMHelpDataOtherEnglishHelpSDMIndexFilenet.tunnelblick.tunnelblick.help*",
    "~LibraryCachesnet.tunnelblick.tunnelblick",
    "~LibraryPreferencesnet.tunnelblick.tunnelblick.plist",
  ]

  caveats <<~EOS
    For security reasons, #{token} must be installed to Applications,
    and will request to be moved at launch.
  EOS
end