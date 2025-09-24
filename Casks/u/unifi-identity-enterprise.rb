cask "unifi-identity-enterprise" do
  version "0.89.2,1e8bca14-01d8-4981-a231-0e50f27f414e,e39c"
  sha256 "755d67b34e755c4e21638b06b97d096e10b377ccbeb334b1386ceca51ed203f2"

  url "https://fw-download.ubnt.com/data/uid-ui-desktop-app/#{version.csv.third}-macOS-#{version.csv.first}-#{version.csv.second}.pkg",
      verified: "fw-download.ubnt.com/data/uid-ui-desktop-app/"
  name "UniFi Identity Enterprise"
  desc "Corporate Wi-Fi, VPN, SSO, and HR Application"
  homepage "https://www.ui.com/identity"

  livecheck do
    url "https://download.uid.ui.com/?app=UI-DESKTOP-MACOS"
    regex(/(\w+)[._-]macOS[._-](\d+(?:\.\d+)+)[._-](\h{8}-\h{4}-\h{4}-\h{4}-\h{12})/i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.match(regex)
      next if match.blank?

      "#{match[2]},#{match[3]},#{match[1]}"
    end
  end

  depends_on macos: ">= :big_sur"

  pkg "#{version.csv.third}-macOS-#{version.csv.first}-#{version.csv.second}.pkg"

  uninstall launchctl: [
              "application.com.ui.uid.desktop.25686722.25686727",
              "com.ui.uid.desktop.privilegedtool",
              "com.ui.uid.desktop.startup",
            ],
            quit:      "com.ui.uid.desktop",
            pkgutil:   [
              "com.ui.uid.desktop",
              "com.ui.uid.mac",
            ]

  zap trash: [
    "~/Library/Application Support/com.ui.uid.desktop",
    "~/Library/Caches/com.ui.uid.desktop",
    "~/Library/Logs/UI",
    "~/Library/Preferences/com.ui.uid.desktop.plist",
    "~/Library/Saved Application State/com.ui.uid.desktop.savedState",
  ]
end