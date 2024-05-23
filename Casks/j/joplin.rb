cask "joplin" do
  arch arm: "-arm64"

  version "2.14.22"
  sha256 arm:   "aefb0867b74e23dff21f403ed7592c11251dce76b0701401c30c02a1661eff80",
         intel: "0e626e683a88a74569b58c9d26a6a72e278e2c4dc97646395a5b3475bf893eb1"

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