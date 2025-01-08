cask "joplin" do
  arch arm: "-arm64"

  version "3.2.8"
  sha256 arm:   "75eb11ad5acb1646bfac37b4c7bfafe7563e525e2c44e64511925d66c1bb7a05",
         intel: "3a1103ce8e7048796424e8bf30759a1546646199dc02604bd8b15d0ad3da0764"

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