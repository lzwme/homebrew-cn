cask "joplin" do
  arch arm: "-arm64"

  version "3.1.24"
  sha256 arm:   "1ed1ee65084892223c1ab841f6708e4c037584eb3ef4f38915122c454362918b",
         intel: "39fe955d7e34b428acfa8bb6e8bb4928e666ffcecfdebb131ed9ef483c05f156"

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