cask "timelane" do
  version "2.0"
  sha256 "3334fbb6945d1f0cb8f535c399297356037f4fdd5c570fd7a7325f5b4bd8b57a"

  url "https:github.comicanzilbTimelanereleasesdownload#{version}Timelane.app-#{version}.zip"
  name "Timelane"
  desc "Profiler for asynchronous code"
  homepage "https:github.comicanzilbTimelane"

  livecheck do
    url "https:raw.githubusercontent.comicanzilbTimelanemasterappcastupdates.xml"
    strategy :sparkle
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
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