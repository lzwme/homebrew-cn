cask "gather" do
  arch arm: "-arm64"

  version "1.4.0"
  sha256 arm:   "f58fe89e2e041707f81fb5256a610a64442ae572df44a36fbb4bdb0777b5b967",
         intel: "8eb1145f76a7a90ebfc46e412cfb44c33da1292bab3fe9e9c2def4c3d6d3802c"

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