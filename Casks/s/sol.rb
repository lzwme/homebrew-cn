cask "sol" do
  version "2.1.165"
  sha256 "c54dd1519e7521cf5fe6a82ca5900e2a244b03a5c7b90a80a949a3743ffd0a2e"

  url "https:github.comospfrancosolreleasesdownload#{version}#{version}.zip"
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