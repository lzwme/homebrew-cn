cask "triliumnext-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.94.0"
  sha256 arm:   "7e384342319f07670ec1a7a78578299def6b9eeb3823ee1a7245b8d39c6fbdc6",
         intel: "2c63ae136b1fe5abc4effe2164a8d1fdb4d9a131740e8d10495b536c8a1d6a59"

  url "https:github.comTriliumNextNotesreleasesdownloadv#{version}TriliumNextNotes-v#{version}-macos-#{arch}.dmg",
      verified: "github.comTriliumNextNotes"
  name "TriliumNext Notes"
  desc "Hierarchical note taking application"
  homepage "https:triliumnext.github.ioDocs"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "TriliumNext Notes.app"

  zap trash: [
    "~LibraryApplication Supporttrilium-data",
    "~LibraryApplication SupportTriliumNext Notes",
    "~LibraryPreferencescom.electron.triliumnext-notes.plist",
    "~LibrarySaved Application Statecom.electron.triliumnext-notes.savedState",
  ]
end