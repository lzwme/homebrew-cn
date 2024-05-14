cask "gather" do
  arch arm: "-arm64"

  version "1.7.1"
  sha256 arm:   "492a29889ddbb2143bcebdc7ae7e1ac5d5e2f277e41de9f3773880c752185b20",
         intel: "264e5b4781efd8526e22981426199924f1f259f5a756eff7531c3cf0f0ed6958"

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