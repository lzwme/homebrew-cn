cask "sol" do
  version "2.1.43"
  sha256 "ead9f331f445be9e292068ef2a740c5fa8e846887b9e498947316255d5b24bae"

  url "https:raw.githubusercontent.comospfrancosolmainreleases#{version}.zip",
      verified: "raw.githubusercontent.comospfrancosol"
  name "Sol"
  desc "Launcher & command palette"
  homepage "https:github.comospfrancosol"

  livecheck do
    url "https:raw.githubusercontent.comospfrancosolmainreleasesappcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :big_sur"

  app "Sol.app"

  uninstall launchctl: "com.ospfranco.sol-LaunchAtLoginHelper",
            quit:      "com.ospfranco.sol"

  zap trash: [
    "~LibraryApplication Scriptscom.ospfranco.sol-LaunchAtLoginHelper",
    "~LibraryApplication Supportcom.ospfranco.sol",
    "~LibraryContainerscom.ospfranco.sol-LaunchAtLoginHelper",
    "~LibraryHTTPStoragescom.ospfranco.sol",
    "~LibraryPreferencescom.ospfranco.sol.plist",
  ]
end