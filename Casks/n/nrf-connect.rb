cask "nrf-connect" do
  arch arm: "arm64", intel: "x64"

  version "5.1.0"
  sha256 arm:   "6e3aa5622e6afb5ef8e98083f0adf8cca9f42a38abc7b5c996e4510d203342f0",
         intel: "92095d96eeb2910a74f59d870adf1137c2f3413192e0a96b83a69b81b84d1408"

  url "https:github.comNordicSemiconductorpc-nrfconnect-launcherreleasesdownloadv#{version}nrfconnect-#{version}-#{arch}.dmg",
      verified: "github.comNordicSemiconductorpc-nrfconnect-launcher"
  name "nRF Connect for Desktop"
  desc "Framework for development on BLE devices"
  homepage "https:www.nordicsemi.comProductsDevelopment-toolsnRF-Connect-for-Desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "nRF Connect for Desktop.app"

  zap trash: [
    "~.nrfconnect-apps",
    "~LibraryApplication Supportnrfconnect",
    "~LibraryPreferencescom.nordicsemi.nrfconnect.plist",
    "~LibrarySaved Application Statecom.nordicsemi.nrfconnect.savedState",
  ]
end