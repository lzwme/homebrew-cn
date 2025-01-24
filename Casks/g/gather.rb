cask "gather" do
  arch arm: "-arm64"

  version "1.25.0"
  sha256 arm:   "3a331a0380f0f729946d7c23653217c1892b0b9a16fc9f7bc63a8287feb1b03c",
         intel: "34ff20511eb8aed3729eda11968c558efbad8736151f3216b3d22804e234b1bd"

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