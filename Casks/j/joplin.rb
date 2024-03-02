cask "joplin" do
  arch arm: "-arm64"

  version "2.14.17"
  sha256 arm:   "398a6c1cf23eeeb88c54d029d89a4196674574951236a36f0667981c3c3acb36",
         intel: "2a3370027259197fc3bc70cfc35e6f1a549b278eece984f9f446a5011b759b1e"

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