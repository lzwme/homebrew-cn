cask "loaf" do
  version "2.0.5"
  sha256 "c245c4bc75c1c0052fec88d84b5a90fc11f9ed1ca28eec673d9b06681d702626"

  url "https:github.comphilipardeljangetloafreleasesdownloadv#{version}loaf.dmg",
      verified: "github.comphilipardeljangetloaf"
  name "Loaf"
  desc "Animated icon library"
  homepage "https:getloaf.io"

  app "Loaf.app"

  zap trash: [
    "~LibraryApplication SupportLoaf",
    "~LibraryLogsLoaf",
    "~LibraryPreferencescom.loaf.studio.plist",
    "~LibrarySaved Application Statecom.loaf.studio.savedState",
  ]

  caveats do
    requires_rosetta
  end
end