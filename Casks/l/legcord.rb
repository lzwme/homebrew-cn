cask "legcord" do
  version "1.0.2"
  sha256 "d9cd29570d523535ec4b042ca9c8c6a1b2f14a34aeb360fa042a35aa1fb210eb"

  url "https:github.comlegcordlegcordreleasesdownloadv#{version}legcord-#{version}-mac-universal.dmg",
      verified: "github.comlegcordlegcord"
  name "Legcord"
  desc "Custom Discord client"
  homepage "https:legcord.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "legcord.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.legcord.legcord.sfl*",
    "~LibraryApplication Supportlegcord",
    "~LibraryPreferencesapp.legcord.Legcord.plist",
    "~LibrarySaved Application Stateapp.legcord.Legcord.savedState",
  ]
end