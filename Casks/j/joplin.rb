cask "joplin" do
  arch arm: "-arm64"

  version "3.2.13"
  sha256 arm:   "70543d378246fc0af3bf5830dc77cc6277dee0aae14cd73ab73e6f60d474f964",
         intel: "eecee19aba227c2ba79c0f3b1a445a183bad67c1c47e9ec50b4e16f40fb834fd"

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