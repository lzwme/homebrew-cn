cask "legcord" do
  version "1.0.4"
  sha256 "24897bb7e6afe5e128aab07f8e99b8eb7e46c916ed3b6540ddf38546fceaf049"

  url "https:github.comlegcordlegcordreleasesdownloadv#{version}legcord-#{version}-mac-universal.dmg",
      verified: "github.comlegcordlegcord"
  name "Legcord"
  desc "Custom Discord client"
  homepage "https:legcord.app"

  livecheck do
    url "https:legcord.applatest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: ">= :big_sur"

  app "legcord.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsapp.legcord.legcord.sfl*",
    "~LibraryApplication Supportlegcord",
    "~LibraryPreferencesapp.legcord.Legcord.plist",
    "~LibrarySaved Application Stateapp.legcord.Legcord.savedState",
  ]
end