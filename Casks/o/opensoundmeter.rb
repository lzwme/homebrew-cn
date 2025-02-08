cask "opensoundmeter" do
  arch arm: "arm", intel: "intel"

  version "1.4.1"
  sha256 arm:   "245f2c3f7b8d0075c6f20df9905b0a938f99ae60f31cc240d7e511fc7eed7182",
         intel: "fd361e31639098771e825d79df4f720b29a77892ca8ee2242c8c88251fefdf6b"

  url "https:github.compsmokotninosmreleasesdownloadv#{version}OpenSoundMeter_#{arch}.dmg",
      verified: "github.compsmokotninosm"
  name "Open Sound Meter"
  desc "Sound measurement application for tuning audio systems in real-time"
  homepage "https:opensoundmeter.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "OpenSoundMeter.app"

  zap trash: [
    "~.configopensoundmeter",
    "~LibraryCachesOpenSoundMeter",
    "~LibraryPreferencescom.opensoundmeter.OpenSoundMeter.plist",
    "~LibrarySaved Application Statecom.opensoundmeter.OpenSoundMeter.savedState",
  ]
end