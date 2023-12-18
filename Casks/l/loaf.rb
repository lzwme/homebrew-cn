cask "loaf" do
  version "2.0.1"
  sha256 "c38387af7f4acbaa68d5e24416a3c19dab987b0bd0cc702184b98b8df75f213e"

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