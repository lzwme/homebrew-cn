cask "mindmac" do
  version "1.9.20"
  sha256 "eac287f7b0bdc1906d5c4a01d43f283c568eeefc0bc88d94fd8def3992ac69d6"

  url "https:github.comMindMacAppMindMacreleasesdownload#{version}MindMac_#{version}.dmg",
      verified: "github.comMindMacAppMindMac"
  name "MindMac"
  desc "ChatGPT client"
  homepage "https:mindmac.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "MindMac.app"

  zap trash: [
    "~LibraryApplication Supportapp.mindmac.macos",
    "~LibraryApplication SupportMindMac",
    "~LibraryCachesapp.mindmac.macos",
    "~LibraryCachescom.crashlytics.dataapp.mindmac.macos",
    "~LibraryCachescom.plausiblelabs.crashreporter.dataapp.mindmac.macos",
    "~LibraryContainersorg.sparkle-project.DownloaderDataLibraryCachesapp.mindmac.macos",
    "~LibraryHTTPStoragesapp.mindmac.macos",
    "~LibraryHTTPStoragesapp.mindmac.macos.binarycookies",
    "~LibraryPreferencesapp.mindmac.macos.plist",
    "~LibrarySaved Application Stateapp.mindmac.macos.savedState",
    "~LibraryWebKitapp.mindmac.macos",
  ]
end