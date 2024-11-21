cask "gather" do
  arch arm: "-arm64"

  version "1.20.0"
  sha256 arm:   "3deb6e570cb5cb1aecadfdd5568d08f63f27b4995801014a72ba957fe398446b",
         intel: "ab19e89de40e18fcb9406e20444ff3af7f558a3f74c6237689746374e88ca535"

  url "https:github.comgathertowngather-town-desktop-releasesreleasesdownloadv#{version}Gather-#{version}#{arch}-mac.zip",
      verified: "github.comgathertowngather-town-desktop-releases"
  name "Gather Town"
  desc "Virtual video-calling space"
  homepage "https:gather.town"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "Gather.app"

  zap trash: [
    "~LibraryApplication SupportGather",
    "~LibraryLogsGather",
    "~LibraryPreferencescom.gather.Gather.plist",
    "~LibrarySaved Application Statecom.gather.Gather.savedState",
  ]
end