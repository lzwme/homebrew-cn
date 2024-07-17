cask "mqttx" do
  arch arm: "-arm64"

  version "1.10.1"
  sha256 arm:   "195c0837f544c553f2335dfc59e0f6a9f65343020d7320327703e6d51ca467b3",
         intel: "74dc05a90fbf1cf801452df95012cec0698e99afac7978aef5ed2b2fb445883d"

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