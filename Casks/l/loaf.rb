cask "loaf" do
  version "2.0.2"
  sha256 "847825516079093d3c0cf3ee88ede88b5584e9f0f674d83b878947cfa00d2e97"

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
end