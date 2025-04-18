cask "timelane" do
  version "2.0"
  sha256 "3334fbb6945d1f0cb8f535c399297356037f4fdd5c570fd7a7325f5b4bd8b57a"

  url "https:github.comicanzilbTimelanereleasesdownload#{version}Timelane.app-#{version}.zip",
      verified: "github.comicanzilbTimelane"
  name "Timelane"
  homepage "https:timelane.tools"

  depends_on macos: ">= :mojave"

  app "Timelane.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.underplot.timelane.sfl*",
    "~LibraryHTTPStoragescom.underplot.timelane",
    "~LibraryPreferencescom.underplot.timelane.plist",
    "~LibrarySaved Application Statecom.underplot.timelane.savedState",
  ]

  caveats do
    requires_rosetta
  end
end