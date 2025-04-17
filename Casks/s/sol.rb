cask "sol" do
  version "2.1.178"
  sha256 "a81e87924d7750764bec2c7b939d2235dace2cf53843b2d9fb232a1d779d80a2"

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