cask "qownnotes" do
  version "25.5.8"
  sha256 "5ac3bb1bb1ffc3ef193dd9384a55abeb9d49d4afcab9c32dd49020a989105c43"

  url "https:github.compbekQOwnNotesreleasesdownloadv#{version}QOwnNotes.dmg",
      verified: "github.compbekQOwnNotes"
  name "QOwnNotes"
  desc "Plain-text file notepad and todo-list manager"
  homepage "https:www.qownnotes.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "QOwnNotes.app"

  zap trash: [
    "~LibraryPreferencescom.pbe.QOwnNotes.plist",
    "~LibrarySaved Application Statecom.PBE.QOwnNotes.savedState",
  ]

  caveats do
    requires_rosetta
  end
end