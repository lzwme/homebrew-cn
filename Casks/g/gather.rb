cask "gather" do
  arch arm: "-arm64"

  version "1.15.2"
  sha256 arm:   "feb478c417c392f845a19442a3c29a5a37dbbf539af8449238a5b5cd2903cdd8",
         intel: "ebac24e102465b7c2956c56bf2c5a9f2564d5e8e00137959242054a8ace5d692"

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