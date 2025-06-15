cask "morkro-papyrus" do
  version "1.0.3"
  sha256 "6130e0d93486db9e969686270e8edddc9be16b52b342fdb4d31eb4546d161118"

  url "https:github.commorkropapyrusreleasesdownload#{version}Papyrus-osx-#{version}.zip"
  name "Papyrus"
  desc "Unofficial Dropbox Paper desktop app"
  homepage "https:github.commorkropapyrus"

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "papyrus"

  app "Papyrus.app"

  zap trash: [
    "~LibraryApplication SupportPapyrus",
    "~LibraryPreferencescom.electron.papyrus.plist",
    "~LibrarySaved Application Statecom.electron.papyrus.savedState",
  ]

  caveats do
    requires_rosetta
  end
end