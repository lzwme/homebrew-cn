cask "notes-better" do
  version "2.2.1"
  sha256 "8148f8239abc5352e8abc9adac181f109994c616ff652d505e93b341c94138aa"

  url "https:github.comnuttyartistnotesreleasesdownloadv#{version}Notes.#{version}.dmg",
      verified: "github.comnuttyartistnotes"
  name "Notes"
  desc "Simple note-taking app for markdown and kanban"
  homepage "https:get-notes.com"

  depends_on macos: ">= :catalina"

  app "Notes Better.app"

  zap trash: [
    "~LibraryCachesNotes",
    "~LibraryPreferencesio.github.nuttyartist.notes.plist",
    "~LibrarySaved Application Stateio.github.nuttyartist.notes.savedState",
  ]
end