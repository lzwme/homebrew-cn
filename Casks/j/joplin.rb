cask "joplin" do
  arch arm: "-arm64"

  version "3.1.22"
  sha256 arm:   "f55e126e72d027cc96b3a409d06cee5ac89e7562dab87dd923e0a039f397e5a6",
         intel: "e7f9b6aac274b6498c4197104a2659bfb92950e1993947c5c53e4fedc96cc6ec"

  url "https:github.comlaurent22joplinreleasesdownloadv#{version}Joplin-#{version}#{arch}.DMG",
      verified: "github.comlaurent22joplin"
  name "Joplin"
  desc "Note taking and to-do application with synchronisation capabilities"
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