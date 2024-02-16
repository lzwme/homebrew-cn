cask "joplin" do
  arch arm: "-arm64"

  version "2.13.15"
  sha256 arm:   "e822976bfb5de7aecdb734d5ee5694ee5f71c3c58e07d45947a235bd778bbb2a",
         intel: "30504e600eb0780c062e9fdecdf539f11bd2946145964834165731eb8abb5a8f"

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