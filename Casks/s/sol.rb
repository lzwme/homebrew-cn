cask "sol" do
  version "2.1.243"
  sha256 "39878fe26695c0995e7a6773d0dd323b779e5b54581e18da5ef52079639c0fc3"

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