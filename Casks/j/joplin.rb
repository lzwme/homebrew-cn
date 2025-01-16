cask "joplin" do
  arch arm: "-arm64"

  version "3.2.11"
  sha256 arm:   "de0b8671f5ed07f5c794332a2320b2da8110752fcb04ab3e49c843314d866d7f",
         intel: "bce47d2a4b7e6f56eb32018469ddb8ab10abfee406cecb3d4b2744c563071e1b"

  url "https:github.comlaurent22joplinreleasesdownloadv#{version}Joplin-#{version}#{arch}.DMG",
      verified: "github.comlaurent22joplin"
  name "Joplin"
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https:joplinapp.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Joplin.app"

  zap trash: [
    "~LibraryApplication SupportJoplin",
    "~LibraryPreferencesnet.cozic.joplin-desktop.helper.plist",
    "~LibraryPreferencesnet.cozic.joplin-desktop.plist",
    "~LibrarySaved Application Statenet.cozic.joplin-desktop.savedState",
  ]
end