cask "qownnotes" do
  version "25.2.4"
  sha256 "8dbacbd2119b625e171175299fdc8761dc4acfdd992278e15cf126eaa2816671"

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