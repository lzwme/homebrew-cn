cask "legcord" do
  version "1.1.5"
  sha256 "42d5c2f12308944e0e4475c8840a458fcf7859cb5aa28d8d6c73f81319d6a6e2"

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