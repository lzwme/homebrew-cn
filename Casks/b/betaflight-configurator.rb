cask "betaflight-configurator" do
  version "10.10.0"
  sha256 "a9ddadd2d983e62865cab7a3839f5a6513e3c839a0c4c3c79b5fa9730ed5a3bd"

  url "https:github.combetaflightbetaflight-configuratorreleasesdownload#{version}betaflight-configurator_#{version}_macOS.dmg"
  name "Betaflight-Configurator"
  desc "Configuration tool for the Betaflight firmware"
  homepage "https:github.combetaflightbetaflight-configurator"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Betaflight Configurator.app"

  zap trash: [
    "~LibraryApplication Supportbetaflight-configurator",
    "~LibraryCachesbetaflight-configurator",
    "~LibraryPreferencescom.nw-builder.betaflight-configurator.plist",
    "~LibrarySaved Application Statecom.nw-builder.betaflight-configurator.savedState",
  ]

  caveats do
    requires_rosetta
  end
end