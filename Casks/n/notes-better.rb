cask "notes-better" do
  version "2.3.0"
  sha256 "f9525c711ecadfccb5f2a90f4ffa51ff2fa918e69ee01991dc4b00b50e8ab32d"

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

  caveats do
    requires_rosetta
  end
end