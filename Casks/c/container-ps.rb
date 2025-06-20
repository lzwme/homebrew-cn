cask "container-ps" do
  version "1.3.0"
  sha256 "8a710ff70ed79d7ca93d51461d77a3268cdb8c3aa985ce4d0b99686b36b62069"

  url "https:github.comToinanecontainer-psreleasesdownload#{version}Container.PS-#{version}.dmg"
  name "Container PS"
  desc "App to show all docker images"
  homepage "https:github.comToinanecontainer-ps"

  no_autobump! because: :requires_manual_review

  app "Container PS.app"

  zap trash: [
    "~LibraryApplication Supportcontainer-ps",
    "~LibraryPreferencescom.electron.container-ps.plist",
    "~LibrarySaved Application Statecom.electron.container-ps.savedState",
  ]

  caveats do
    requires_rosetta
  end
end