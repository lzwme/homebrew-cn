cask "mqttx" do
  arch arm: "-arm64"

  version "1.9.10"
  sha256 arm:   "43e8db6f5c953a82cbdb2b04eafbc5792b7075640ccaf2a14e70677eade8c5c2",
         intel: "92d41cbde4d96b73d391010186606b2ff1019c1540ef71fed5cb573dd1a9f165"

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