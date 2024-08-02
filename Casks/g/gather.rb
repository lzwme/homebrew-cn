cask "gather" do
  arch arm: "-arm64"

  version "1.11.11"
  sha256 arm:   "7e9723b728a8f97c8b108ca2e32e7519679ba399f324f6ec4a77d355b3e1d4b2",
         intel: "0a65406d42cd052e733f219f0928c1d0baa6611e28b661df6686e544b028aae8"

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