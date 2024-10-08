cask "gather" do
  arch arm: "-arm64"

  version "1.15.1"
  sha256 arm:   "c372112373e6a7a1db2f211f8f2de8d6d8e16b4b4e01d81611319bd8040cb9e8",
         intel: "9fa8f93359617abec08ff92c91409ac253077aee0f6c31e523a5dd334ed3c42b"

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