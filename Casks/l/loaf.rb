cask "loaf" do
  version "2.0.9"
  sha256 "e01953ba3fa4f84daf3a5b0ca0cfe730958f2f1d4a674bbaf7eab31bcfd0012e"

  url "https:github.comphilipardeljangetloafreleasesdownloadv#{version}loaf.dmg",
      verified: "github.comphilipardeljangetloaf"
  name "Loaf"
  desc "Animated icon library"
  homepage "https:getloaf.io"

  no_autobump! because: :requires_manual_review

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