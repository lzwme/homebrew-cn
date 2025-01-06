cask "gather" do
  arch arm: "-arm64"

  version "1.23.1"
  sha256 arm:   "934bc200f946e94f9dc6b5c2929a220eb28aa257c211bd86784c034977815a38",
         intel: "1b6fc72fa0fe9110253aeb61c52cf216cd8a712625fb0fc9d9781eccc4fb1d3b"

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
  depends_on macos: ">= :big_sur"

  app "Gather.app"

  zap trash: [
    "~LibraryApplication SupportGather",
    "~LibraryLogsGather",
    "~LibraryPreferencescom.gather.Gather.plist",
    "~LibrarySaved Application Statecom.gather.Gather.savedState",
  ]
end