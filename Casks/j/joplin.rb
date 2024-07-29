cask "joplin" do
  arch arm: "-arm64"

  version "3.0.14"
  sha256 arm:   "151b917585f2ff79a307851cba8c16495c77c9f566dcc4ac744f9e96986712d7",
         intel: "14eb34a19ddb2e82726a537dd7f2c02cc4a053fae46c1a637277fa7d191092d8"

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