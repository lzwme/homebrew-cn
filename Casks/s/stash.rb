cask "stash" do
  version "4.0.0,405"
  sha256 "d78d35bbb983c17869106a4a2734e3ad9cd1119694f0c4d27cbe764d59197172"

  url "https://mac-release-static.stash.ws/Stash-build-#{version.csv.second}.zip"
  name "Stash"
  desc "Network tool based on Clash"
  homepage "https://stash.ws/"

  livecheck do
    url "https://mac-release.stash.ws/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Stash.app"

  uninstall quit:   "ws.stash.app.mac",
            delete: [
              "/Library/LaunchDaemons/ws.stash.app.mac.daemon.helper.plist",
              "/Library/PrivilegedHelperTools/ws.stash.app.mac.daemon.helper",
            ]

  zap trash: [
    "~/Library/Application Scripts/group.ws.stash.app",
    "~/Library/Application Scripts/ws.stash.app",
    "~/Library/Application Scripts/ws.stash.app.mac-LaunchAtLoginHelper",
    "~/Library/Application Support/Stash",
    "~/Library/Application Support/ws.stash.app.mac",
    "~/Library/Caches/ws.stash.app.mac",
    "~/Library/Caches/ws.stash.app.mac.dashboard",
    "~/Library/Containers/ws.stash.app.mac-LaunchAtLoginHelper",
    "~/Library/Group Containers/group.ws.stash.app",
    "~/Library/HTTPStorages/ws.stash.app.mac",
    "~/Library/HTTPStorages/ws.stash.app.mac.binarycookies",
    "~/Library/Preferences/ws.stash.app.mac.plist",
  ]
end