cask "mindmac" do
  version "1.8.6"
  sha256 "8ff63d298b2c6501050860b579c04dc7adcacea042476c682db06461547be3e9"

  url "https:github.comMindMacAppMindMacreleasesdownload#{version}MindMac_#{version}.dmg",
      verified: "github.comMindMacAppMindMac"
  name "MindMac"
  desc "ChatGPT client"
  homepage "https:mindmac.app"

  depends_on macos: ">= :ventura"

  app "MindMac.app"

  zap trash: [
    "~LibraryApplication Supportapp.mindmac.macos",
    "~LibraryApplication SupportMindMac",
    "~LibraryCachesapp.mindmac.macos",
    "~LibraryPreferencesapp.mindmac.macos.plist",
    "~LibrarySaved Application Stateapp.mindmac.macos.savedState",
  ]
end