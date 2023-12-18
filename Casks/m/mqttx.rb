cask "mqttx" do
  arch arm: "-arm64"

  version "1.9.7"
  sha256 arm:   "f9136f189ba6e78e64ded7b9ef8a59e462f99b9d0f81df3d53e592a5f9c1e4bb",
         intel: "31e6ba10e181c531d32545fe6b0409a234d7a86eb24e8e5192a183e69885494d"

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