cask "gather" do
  arch arm: "-arm64"

  version "1.14.0"
  sha256 arm:   "c7b6f461813ace621049ab104ffc10e430ce069b2e64f3c2fa07932881d5db34",
         intel: "80d6807ff895486d375436383fec334cdf714599849603661fc79458a0244e9b"

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