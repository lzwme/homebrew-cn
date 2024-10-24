cask "gather" do
  arch arm: "-arm64"

  version "1.16.1"
  sha256 arm:   "04f0e97ce76008bceef45285ed741ef398c151a8fb864106f1fd741f6e60e94a",
         intel: "c71f445b888b92e1ec28ec44435ac99e36be39857d0b7f2e1724f1fd808b7b1a"

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