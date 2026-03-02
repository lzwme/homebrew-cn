cask "netviews" do
  version "2.7"
  sha256 "e6c1c1036f71a33f0f161dc8be84dbeb6779f37c47be2c32c3482287fecf3125"

  url "https://www.netviews.app/installers/NetViews-#{version}.zip"
  name "NetViews"
  desc "Network and Wi-Fi diagnostic tool"
  homepage "https://www.netviews.app/"

  livecheck do
    url "https://www.netviews.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "NetViews.app"

  uninstall launchctl: "com.bmmup.pingstalker.ChmodBPF",
            quit:      "com.bmmup.PingStalker",
            delete:    [
              "/Library/Application Support/PingStalker/ChmodBPF",
              "/Library/LaunchDaemons/com.bmmup.pingstalker.ChmodBPF.plist",
            ]

  zap trash: [
    "~/Library/Application Support/NetViews",
    "~/Library/Caches/com.bmmup.PingStalker",
    "~/Library/HTTPStorages/com.bmmup.PingStalker",
    "~/Library/Preferences/com.bmmup.PingStalker.plist",
  ]
end