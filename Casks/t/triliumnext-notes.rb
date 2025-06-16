cask "triliumnext-notes" do
  arch arm: "arm64", intel: "x64"

  version "0.95.0"
  sha256 arm:   "4b1d7e166c61fe6604374ea8eb105a0c257c861a7124d1c2d5195f8ed1aaf205",
         intel: "1521606e94ad11eb642cd04d49c5baccd7ed09fd1468e7fb7def14e08f20629f"

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