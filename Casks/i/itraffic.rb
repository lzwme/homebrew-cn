cask "itraffic" do
  version "0.1.6"
  sha256 "9ab2db0196ae0ffa0d6f9f66f27ed041c4fe77266cb7d978cc0ff8a25376f9d2"

  url "https:github.comfoamzouITraffic-monitor-for-macreleasesdownloadv#{version}ITraffic-v#{version}.zip"
  name "itraffic"
  desc "Monitor for displaying process traffic on status bar"
  homepage "https:github.comfoamzouITraffic-monitor-for-mac"

  depends_on macos: ">= :catalina"

  app "ITraffic.app"

  zap trash: [
    "~LibraryApplication Scriptscom.foamzou.ITrafficMonitorForMac",
    "~LibraryApplication SupportITraffic",
    "~LibraryContainerscom.foamzou.ITrafficMonitorForMac",
    "~LibraryPreferencescom.foamzou.ITrafficMonitorForMac.plist",
  ]
end