cask "editaro" do
  version "1.7.1"
  sha256 "e5efe1de1283df05ad0bb2908c16c02bc0c34806119e83daefc0f049286f3c58"

  url "https:github.comkkosugeeditaroreleasesdownload#{version}Editaro-#{version}-mac.zip",
      verified: "github.comkkosugeeditaro"
  name "Editaro"
  desc "Text editor"
  homepage "https:editaro.com"

  app "Editaro.app"

  zap trash: [
    "~LibraryApplication SupportEditaro",
    "~LibraryCachescom.electron.editaro",
    "~LibraryCachescom.electron.editaro.ShipIt",
    "~LibraryHTTPStoragescom.electron.editaro",
    "~LibraryLogsEditaro",
    "~LibraryPreferencescom.electron.editaro.helper.plist",
    "~LibraryPreferencescom.electron.editaro.plist",
    "~LibrarySaved Application Statecom.electron.editaro.savedState",
  ]

  caveats do
    requires_rosetta
  end
end