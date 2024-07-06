cask "gather" do
  arch arm: "-arm64"

  version "1.10.1"
  sha256 arm:   "75f1a28c7e035eda0d93f39fc291de150e99f79a3bed86b59bfe7b0bc1e18d66",
         intel: "ca763c9fc25dc35e9bc4bf69013c3893bbc419a893c686924734e4c06bfd57ca"

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