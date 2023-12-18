cask "betaflight-configurator" do
  version "10.9.0"
  sha256 "e5c6cbcdd513fe33ff3a357ff6a19c4914bfb8f40b10cbb109e7a5752d3e33a7"

  url "https:github.combetaflightbetaflight-configuratorreleasesdownload#{version}betaflight-configurator_#{version}_macOS.dmg"
  name "Betaflight-Configurator"
  desc "Configuration tool for the Betaflight firmware"
  homepage "https:github.combetaflightbetaflight-configurator"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Betaflight Configurator.app"

  zap trash: [
    "~LibraryApplication Supportbetaflight-configurator",
    "~LibraryCachesbetaflight-configurator",
    "~LibraryPreferencescom.nw-builder.betaflight-configurator.plist",
    "~LibrarySaved Application Statecom.nw-builder.betaflight-configurator.savedState",
  ]
end