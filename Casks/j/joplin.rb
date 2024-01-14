cask "joplin" do
  arch arm: "-arm64"

  version "2.13.14"
  sha256 arm:   "63fdfd110f650bcac17d190985c070ba4b2e968aa38f69816fe25258c8fac60d",
         intel: "c6cc4165931cbbd900ca736de15043731d37e51599615a406e48734c78e75800"

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