cask "mqttx" do
  arch arm: "-arm64"

  version "1.10.0"
  sha256 arm:   "8b76d7deda6e5e46e010087f8234564d6c35b3dc3c37db8a771d56609c27276d",
         intel: "75c070d14239abcf1f515d8d79518a7c4f6e9a7e300fc3a342c5e07c4c9bbf5d"

  url "https:github.comemqxMQTTXreleasesdownloadv#{version}MQTTX-#{version}#{arch}.dmg",
      verified: "github.comemqxMQTTX"
  name "MQTTX"
  desc "Cross-platform MQTT 5.0 Desktop Client"
  homepage "https:mqttx.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "MQTTX.app"

  zap trash: [
    "~LibraryApplication SupportMQTTX",
    "~LibraryLogsMQTTX",
    "~LibraryPreferencescom.electron.mqttx.plist",
    "~LibrarySaved Application Statecom.electron.mqttx.savedState",
  ]
end