cask "joplin" do
  arch arm: "-arm64"

  version "3.2.12"
  sha256 arm:   "809cea6e92aaecd56b93365b22a53580b2b64261e3877f77e6388ea87c5a4a30",
         intel: "f315afbd40438c1ffbbcd535d817c7df37befadc26ba26231c86b681d81749b4"

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