cask "joplin" do
  arch arm: "-arm64"

  version "2.13.11"
  sha256 arm:   "38cf8b7b67357acbc4f3e43000ca57734df22d4c3189b29145cdfb59a4c69d3b",
         intel: "fd3f0e91320843a0299cbd32e7ec51764425072cd74b0ae9c39c17a9b8684a81"

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