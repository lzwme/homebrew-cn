cask "joplin" do
  arch arm: "-arm64"

  version "2.14.19"
  sha256 arm:   "8986835294fccf947e653cf3f84f6f1d8e37f0540d576cd6917834a86147813b",
         intel: "476eab50c33e1bf5311228260b3762ad74c7aa2caeadd5ac35aa2b73188554e1"

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