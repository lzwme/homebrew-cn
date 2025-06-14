cask "gridea" do
  version "0.9.3"
  sha256 "16c9c9a1fdf4773f165878f995a9eb4b0a9c6eb815410a723170623dd23e4354"

  url "https:github.comgetgrideagrideareleasesdownloadv#{version}Gridea-#{version}.dmg",
      verified: "github.comgetgrideagridea"
  name "Gridea"
  desc "Static blog writing client"
  homepage "https:gridea.dev"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "Gridea.app"

  zap trash: [
        "~.gridea",
        "~LibraryApplication Supportgridea",
        "~LibraryPreferencescom.electron.gridea.plist",
        "~LibrarySaved Application Statecom.electron.gridea.savedState",
      ],
      rmdir: "~DocumentsGridea"

  caveats do
    requires_rosetta
  end
end