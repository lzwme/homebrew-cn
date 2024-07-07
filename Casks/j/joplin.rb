cask "joplin" do
  arch arm: "-arm64"

  version "3.0.13"
  sha256 arm:   "2ba1aff68aae017464b59903722a70601f18b8e7c3286374e6c0bad064c5b02c",
         intel: "52728d4daf4b031bd3447758f6ff53a23835d8a541bf6d322b71bedaa42de7c5"

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