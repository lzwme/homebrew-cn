cask "gather" do
  arch arm: "-arm64"

  version "0.15.2"
  sha256 arm:   "47720726aa6ba29d5a92aebdeebdff552777d77a14971d260fea1cf13e7ee71d",
         intel: "c9dbb1008f48b6d60435f8697ee98841ab96a2fb61fff601f57f53e24ea02796"

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