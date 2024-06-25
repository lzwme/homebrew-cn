cask "mindmac" do
  version "1.9.17"
  sha256 "d31860b22c63e23cd36366060e4b895a3d4601adeab60c894a42db43c7b5b17d"

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