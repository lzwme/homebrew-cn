cask "dosbox-staging" do
  version "0.81.0"
  sha256 "5d3cec60552b2a34caa70702b35bdf9ce591cf0b03143802351725a7c729d9fe"

  url "https:github.comdosbox-stagingdosbox-stagingreleasesdownloadv#{version}dosbox-staging-macOS-v#{version}.dmg"
  name "DOSBox Staging"
  desc "DOS game emulator"
  homepage "https:github.comdosbox-stagingdosbox-staging"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "DOSBox Staging.app"

  zap trash: "~LibraryPreferencesDOSBox"
end