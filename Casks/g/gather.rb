cask "gather" do
  arch arm: "-arm64"

  version "1.8.0"
  sha256 arm:   "e9cf0d6c14aeca5b6980d214f022b507b60eb3da7e2e9c0686668771018fa866",
         intel: "21eb365d3bf71aedc66546299a431a3cb155b74549c2043a89bc30445084b6e8"

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