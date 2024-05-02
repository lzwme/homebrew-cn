cask "loaf" do
  version "2.0.3"
  sha256 "778eb0405960fb5a28cb7f5d2109a139c00124b2386adc3ee878681f4c68f4e2"

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