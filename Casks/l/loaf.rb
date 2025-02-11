cask "loaf" do
  version "2.0.7"
  sha256 "6bd4b6c558987cab4630ce4b50d09acf71b19a1ef5d029a4023cdea890813b91"

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