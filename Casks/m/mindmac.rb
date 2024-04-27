cask "mindmac" do
  version "1.9.14"
  sha256 "ef8c458467baaec50baf5f8570bb2429225d45dccbd3e4f8cf4c3246f815479c"

  url "https:github.comMindMacAppMindMacreleasesdownload#{version}MindMac_#{version}.dmg",
      verified: "github.comMindMacAppMindMac"
  name "MindMac"
  desc "ChatGPT client"
  homepage "https:mindmac.app"

  livecheck do
    url :url
    strategy :github_latest
  end

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