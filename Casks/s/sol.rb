cask "sol" do
  version "2.1.86"
  sha256 "6002b736b944207bd599f33ca97146b57e5972f3a22ee596f2cd5e69d8640923"

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