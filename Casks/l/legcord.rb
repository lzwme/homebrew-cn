cask "legcord" do
  version "1.1.4"
  sha256 "4ff3ac211027ee1a5d6296709f135cd640fd5fbd69e1705f1839fc5c6393bd23"

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