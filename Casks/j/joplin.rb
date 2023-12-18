cask "joplin" do
  arch arm: "-arm64"

  version "2.13.9"
  sha256 arm:   "a7195ab68e8041876e4c25e8b8654d486af96b0846c250bc8d3906f6707653ee",
         intel: "e0d785563f910770b2090c6b30ced97c56a104c6b45ae998d583ec949dafa2d7"

  url "https:github.comlaurent22joplinreleasesdownloadv#{version}Joplin-#{version}#{arch}.DMG",
      verified: "github.comlaurent22joplin"
  name "Joplin"
  desc "Note taking and to-do application with synchronization capabilities"
  homepage "https:joplinapp.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Joplin.app"

  zap trash: [
    "~LibraryApplication SupportJoplin",
    "~LibraryPreferencesnet.cozic.joplin-desktop.helper.plist",
    "~LibraryPreferencesnet.cozic.joplin-desktop.plist",
    "~LibrarySaved Application Statenet.cozic.joplin-desktop.savedState",
  ]
end