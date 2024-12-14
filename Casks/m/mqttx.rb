cask "mqttx" do
  arch arm: "-arm64"

  version "1.11.1"
  sha256 arm:   "6fef6a1b31108262e141d86912880ae4c64d1ec4bad02c006b812aeeccd8636f",
         intel: "d76528e96a1e85a6ab611e47aad4f07dc0ccb9e950824295b280ec1dbf90a01c"

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