cask "mqtt-explorer" do
  version "0.3.5"
  sha256 "4322a9127c3ce9025d33afa3ff91e76e8873fff260493a112eadc4769c027778"

  url "https:github.comthomasnordquistMQTT-Explorerreleasesdownloadv#{version}MQTT-Explorer-#{version}-mac.zip",
      verified: "github.comthomasnordquistMQTT-Explorer"
  name "MQTT Explorer"
  homepage "https:mqtt-explorer.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MQTT Explorer.app"

  uninstall quit: "de.t7n.apps.mqtt-explorer"

  zap trash: [
    "~LibraryApplication Scriptsde.t7n.apps.mqtt-explorer",
    "~LibraryContainersde.t7n.apps.mqtt-explorer",
    "~LibraryGroup Containers*.de.t7n.apps.mqtt-explorer",
  ]

  caveats do
    requires_rosetta
  end
end