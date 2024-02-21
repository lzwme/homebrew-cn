cask "gather" do
  arch arm: "-arm64"

  version "1.1.0"
  sha256 arm:   "ef500d306598a2b274fbe802abb7757d3c3c02a72eb9faf77766349248330374",
         intel: "1596a96e0423dc0aecd02233350bacaf3cd6d77df06d43fc8d90b9d23cac0d34"

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