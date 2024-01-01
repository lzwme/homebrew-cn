cask "joplin" do
  arch arm: "-arm64"

  version "2.13.12"
  sha256 arm:   "2d6ee6c9313159b9450e47bfa3f13bb4d05106b9323643af9c78b3b484fbc774",
         intel: "e151e2a4f2774e47fb352cbbb32b64efddc0a4e426edc46c9790cd3b4c63a48c"

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