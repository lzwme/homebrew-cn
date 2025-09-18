cask "vpn-tracker-365" do
  # NOTE: "365" is not a version number, but an intrinsic part of the product name
  version "25.2,158"
  sha256 "8af9e9fd6e1c8c9e661d0e5cd86c22508685e05abf32f54eba11e727d2b64901"

  url "https://download.equinux.com/files/other/VPN%20Tracker%20365%20-%20#{version.csv.first}.#{version.csv.second}.zip",
      verified: "download.equinux.com/files/other/"
  name "VPN Tracker 365"
  desc "VPN client: IPsec, L2TP, OpenVPN, PPTP, SSTP, SonicWALL/AnyConnect/Fortinet SSL"
  homepage "https://vpntracker.com/"

  livecheck do
    url "https://www.equinux.com/dlc/?l=/x/products/vpntracker/download.html&cc=com.equinux.VPNTracker&v=365&d"
    regex(/VPN[\s._-]Tracker[\s._-]365[\s._-]+v?(\d+(?:\.\d+)+)[\s._-](\d+(?:\.\d+)*)\.zip/i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  depends_on macos: ">= :big_sur"

  app "VPN Tracker 365.app"

  uninstall delete: [
    "/Library/Application Support/VPN Tracker 365",
    "/Library/Extensions/com.equinux.VPNTracker365.*",
    "/Library/LaunchDaemons/com.equinux.VPNTracker365.agent.plist",
    "/Library/Preferences/com.equinux.VPNTracker365.plist",
    "/Library/PrivilegedHelperTools/com.equinux.VPNTracker365.*",
  ]

  zap trash: [
    "~/Library/Application Support/VPN Tracker 365",
    "~/Library/Preferences/com.equinux.VPNTracker365.plist",
  ]
end