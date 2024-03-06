cask "gather" do
  arch arm: "-arm64"

  version "1.2.1"
  sha256 arm:   "ac0d969d43e757af34236edad016df766f38a7829ecb12f97f2f30f29080e9a8",
         intel: "a90df31171fde96ba8622e12e15559841567ca98acfbeada3647e2fbe5edde16"

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