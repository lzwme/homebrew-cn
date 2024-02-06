cask "gather" do
  arch arm: "-arm64"

  version "1.0.1"
  sha256 arm:   "123b9acbc616e569afaf6558230bf449cb46d78b832e26c6c935b0fe294fa33e",
         intel: "c608623a4fad4f29267607e8da242104704645d90e82b7d161fed0db9efdf5d7"

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