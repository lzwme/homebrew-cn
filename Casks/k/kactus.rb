cask "kactus" do
  version "0.3.35"
  sha256 "e264d004747c21e5332202c1f1337dddeb1f42d6a6c7fe00c3753031ea87b745"

  url "https:github.comkactus-iokactusreleasesdownloadv#{version}Kactus-macos.zip",
      verified: "github.comkactus-iokactus"
  name "Kactus"
  desc "True version control tool for designers"
  homepage "https:kactus.io"

  no_autobump! because: :requires_manual_review

  depends_on cask: "sketch"

  app "Kactus.app"

  zap trash: [
    "~LibraryApplication SupportKactus",
    "~LibraryCachesio.kactus.KactusClient",
    "~LibraryCachesio.kactus.KactusClient.ShipIt",
    "~LibraryHTTPStoragesio.kactus.KactusClient",
    "~LibraryLogsKactus",
    "~LibraryPreferencesio.kactus.Kactus.plist",
    "~LibrarySaved Application Stateio.kactus.Kactus.savedState",
  ]

  caveats do
    requires_rosetta
  end
end