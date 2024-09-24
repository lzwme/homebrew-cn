cask "gather" do
  arch arm: "-arm64"

  version "1.13.1"
  sha256 arm:   "bcf18618ff169d56e45c0dd6a342a877afb67ffa5de3fbf04f62b85b120a5d40",
         intel: "b836dd508a3735c1be2a2dd3ceffdb1b7b96ef8ad99e9f799f995f2c218dfdad"

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