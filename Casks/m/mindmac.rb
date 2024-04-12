cask "mindmac" do
  version "1.9.8"
  sha256 "34e890889fff115dc0e040a18e65c43c01d89cfcfa88385ffa5a496c0a1cef53"

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
    "~LibraryPreferencesapp.mindmac.macos.plist",
    "~LibrarySaved Application Stateapp.mindmac.macos.savedState",
  ]
end