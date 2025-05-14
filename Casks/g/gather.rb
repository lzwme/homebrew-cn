cask "gather" do
  arch arm: "-arm64"

  version "1.32.0"
  sha256 arm:   "e3f9e9e254084ceacb38e71f2e4dfae4b0c59be86c2808cd561e78a0cf5262db",
         intel: "3eef48392273571df29c4910ac19ecda8711b6bdcff518ee7f4cbdf0c6cd1f4a"

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