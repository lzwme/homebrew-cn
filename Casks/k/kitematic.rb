cask "kitematic" do
  version "0.17.13"
  sha256 "d2e3dba17680eec4789851fba376bb573799f448eea7beb2d7aa990f24feb402"

  url "https:github.comdockerkitematicreleasesdownloadv#{version}Kitematic-#{version}-Mac.zip",
      verified: "github.comdockerkitematic"
  name "Kitematic"
  desc "Visual user interface for Docker Container management"
  homepage "https:kitematic.com"

  app "Kitematic.app"

  zap trash: [
    "~Kitematic",
    "~LibraryApplication SupportKitematic",
    "~LibraryCachesKitematic",
    "~LibraryLogsKitematic",
    "~LibraryPreferencescom.electron.kitematic.plist",
    "~LibraryPreferencescom.electron.kitematic.helper.plist",
    "~LibrarySaved Application Statecom.electron.kitematic.savedState",
  ]

  caveats do
    discontinued
  end
end