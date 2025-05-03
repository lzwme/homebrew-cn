cask "joplin" do
  arch arm: "-arm64"

  version "3.3.10"
  sha256 arm:   "665a9066bedf1bddff97bdcf58653bf567051aacaa8fc8828f2e4d3d6361362b",
         intel: "d6272e2f98fb334b402ef9a865b165a21ad2f8f456681d6f63d69939293f3522"

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