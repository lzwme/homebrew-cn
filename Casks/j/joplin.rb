cask "joplin" do
  arch arm: "-arm64"

  version "3.3.12"
  sha256 arm:   "e6476630c2d1c9b4cac94d98440893b121707570492b38423cadecf0aeb7a48e",
         intel: "f209dbda832ef74dd7cc7c7363226fbc13981c47d6a36cc60843ea130f956566"

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